import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import '../../../../data/models/vehicle_model.dart';
import '../../../../widgets/app_input.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/date_picker.dart';
import '../../../../utils/validators.dart';
import '../../../auth/controller/auth_controller.dart';

class VehicleForm extends StatefulWidget {
  final Vehicle? vehicle;
  final void Function(Vehicle) onSubmit;
  final bool loading;

  const VehicleForm({
    super.key,
    this.vehicle,
    required this.onSubmit,
    this.loading = false,
  });

  @override
  State<VehicleForm> createState() => _VehicleFormState();
}

class _VehicleFormState extends State<VehicleForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController numberController;
  late final TextEditingController yearController;
  late final TextEditingController serviceKmController;
  late final TextEditingController batteryController;
  late final TextEditingController alignmentController;
  late final TextEditingController notesController;

  DateTime? insuranceStart;
  DateTime? insuranceEnd;
  DateTime? pollutionStart;
  DateTime? pollutionEnd;
  bool needNotification = false;
  bool sharedWith = false;

  File? imageFile;
  String? existingImageUrl;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    final v = widget.vehicle;

    nameController = TextEditingController(text: v?.vehicleName ?? '');
    numberController = TextEditingController(text: v?.vehicleNumber ?? '');
    yearController = TextEditingController(text: v?.vehicleYear ?? '');
    serviceKmController = TextEditingController(text: v?.serviceKm ?? '');
    batteryController = TextEditingController(text: v?.battery ?? '');
    alignmentController = TextEditingController(text: v?.alignment ?? '');
    notesController = TextEditingController(text: v?.notes ?? '');

    insuranceStart = v?.insuranceStarts;
    insuranceEnd = v?.insuranceEnds;
    pollutionStart = v?.pollutionStarts;
    pollutionEnd = v?.pollutionEnds;
    needNotification = v?.needNotification ?? false;
    sharedWith = v?.sharedWith ?? false;

    existingImageUrl = v?.imageUrl;
  }

  @override
  void dispose() {
    nameController.dispose();
    numberController.dispose();
    yearController.dispose();
    serviceKmController.dispose();
    batteryController.dispose();
    alignmentController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (!mounted) return;

    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
        existingImageUrl = null; // override previous
      });
    }
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

void _submit() {
  if (widget.loading) return;

  if (!(_formKey.currentState?.validate() ?? false)) {
    _showSnack("Please fill required fields.");
    return;
  }

  late AuthController authController;
  try {
    authController = Get.find<AuthController>();
    print("VehicleForm: AuthController found: $authController");
  } catch (e) {
    _showSnack("AuthController not found: $e");
    print("VehicleForm: AuthController not found: $e");
    return;
  }

  final user = authController.userProfile.value;
  print("VehicleForm: User profile from AuthController: $user");

  if (user == null) {
    _showSnack("User profile is null. Ensure user is fetched before opening this page.");
    return;
  }

  final vehicle = Vehicle(
    vehicleId: widget.vehicle?.vehicleId ??
        DateTime.now().millisecondsSinceEpoch.toString(),
    ownerName: user.name,
    vehicleName: nameController.text.trim(),
    vehicleNumber: numberController.text.trim(),
    vehicleYear: yearController.text.trim(),
    createdAt: widget.vehicle?.createdAt ?? DateTime.now(),
    uploadedAt: DateTime.now(),
    insuranceStarts: insuranceStart,
    insuranceEnds: insuranceEnd,
    pollutionStarts: pollutionStart,
    pollutionEnds: pollutionEnd,
    battery: batteryController.text.trim(),
    alignment: alignmentController.text.trim(),
    serviceKm: serviceKmController.text.trim(),
    notes: notesController.text.trim(),
    needNotification: needNotification,
    sharedWith: sharedWith,
    imageUrl: existingImageUrl ?? '',
    userAuthUuid: user.authUuid,
    vehicleAddedBy: user.email,
  );

  print("VehicleForm: Submitting vehicle: ${vehicle.vehicleName}");
  widget.onSubmit(vehicle);
  _showSnack(widget.vehicle == null ? "Vehicle added!" : "Vehicle updated!");
}


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // IMAGE
            Center(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _buildImage(),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: FloatingActionButton.small(
                      heroTag: "pickImageFab",
                      onPressed: _pickImage,
                      child: const Icon(Icons.camera_alt),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),

            AppInput(
              controller: nameController,
              label: 'Vehicle Name',
              validator: Validators.notEmpty,
            ),
            const SizedBox(height: 12),

            AppInput(
              controller: numberController,
              label: 'Vehicle Number',
              validator: Validators.notEmpty,
            ),
            const SizedBox(height: 12),

            AppInput(
              controller: yearController,
              label: 'Vehicle Year',
              validator: Validators.notEmpty,
            ),
            const SizedBox(height: 12),

            AppInput(
              controller: serviceKmController,
              label: 'Service KM',
              validator: Validators.number,
            ),
            const SizedBox(height: 12),

            AppInput(controller: batteryController, label: "Battery (Optional)"),
            const SizedBox(height: 12),

            AppInput(controller: alignmentController, label: "Alignment (Optional)"),
            const SizedBox(height: 12),

            AppInput(controller: notesController, label: "Notes (Optional)"),
            const SizedBox(height: 12),

            DatePicker(
              label: "Insurance Start",
              initialDate: insuranceStart,
              onDateSelected: (d) => setState(() => insuranceStart = d),
            ),
            const SizedBox(height: 12),

            DatePicker(
              label: "Insurance End",
              initialDate: insuranceEnd,
              onDateSelected: (d) => setState(() => insuranceEnd = d),
            ),
            const SizedBox(height: 12),

            DatePicker(
              label: "Pollution Start",
              initialDate: pollutionStart,
              onDateSelected: (d) => setState(() => pollutionStart = d),
            ),
            const SizedBox(height: 12),

            DatePicker(
              label: "Pollution End",
              initialDate: pollutionEnd,
              onDateSelected: (d) => setState(() => pollutionEnd = d),
            ),
            const SizedBox(height: 16),

            SwitchListTile(
              title: const Text("Need Notifications"),
              value: needNotification,
              onChanged: (v) => setState(() => needNotification = v),
            ),
            SwitchListTile(
              title: const Text("Shared With Others"),
              value: sharedWith,
              onChanged: (v) => setState(() => sharedWith = v),
            ),

            const SizedBox(height: 24),

            AppButton(
              label: widget.vehicle == null ? "Add Vehicle" : "Update Vehicle",
              loading: widget.loading,
              onPressed: widget.loading ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (imageFile != null) {
      return Image.file(imageFile!, height: 150, width: 150, fit: BoxFit.cover);
    }

    if (existingImageUrl != null && existingImageUrl!.isNotEmpty) {
      return Image.network(
        existingImageUrl!,
        height: 150,
        width: 150,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _imagePlaceholder(),
      );
    }

    return _imagePlaceholder();
  }

  Widget _imagePlaceholder() {
    return Container(
      height: 150,
      width: 150,
      color: Colors.grey.shade300,
      child: const Icon(Icons.directions_car, size: 50),
    );
  }
}
