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
  late TextEditingController nameController;
  late TextEditingController numberController;
  late TextEditingController yearController;
  late TextEditingController serviceKmController;
  late TextEditingController batteryController;
  late TextEditingController alignmentController;
  late TextEditingController notesController;
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
    nameController = TextEditingController(
      text: widget.vehicle?.vehicleName ?? '',
    );
    numberController = TextEditingController(
      text: widget.vehicle?.vehicleNumber ?? '',
    );
    yearController = TextEditingController(
      text: widget.vehicle?.vehicleYear ?? '',
    );
    serviceKmController = TextEditingController(
      text: widget.vehicle?.serviceKm ?? '',
    );
    batteryController = TextEditingController(
      text: widget.vehicle?.battery ?? '',
    );
    alignmentController = TextEditingController(
      text: widget.vehicle?.alignment ?? '',
    );
    notesController = TextEditingController(text: widget.vehicle?.notes ?? '');
    insuranceStart = widget.vehicle?.insuranceStarts;
    insuranceEnd = widget.vehicle?.insuranceEnds;
    pollutionStart = widget.vehicle?.pollutionStarts;
    pollutionEnd = widget.vehicle?.pollutionEnds;
    needNotification = widget.vehicle?.needNotification ?? false;
    sharedWith = widget.vehicle?.sharedWith ?? false;
    existingImageUrl = widget.vehicle?.imageUrl;
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
    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
        existingImageUrl = null;
      });
    }
  }

  void _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    AuthController? authController;
    try {
      authController = Get.find<AuthController>();
    } catch (e) {
      debugPrint('AuthController not found: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('AuthController not found.')),
      );
      return;
    }
    final user = authController.userProfile.value;
    debugPrint('User profile in VehicleForm: $user');
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in (profile is null)')),
      );
      return;
    }

    // TODO: Upload image to storage and get URL if imageFile != null
    String? imageUrl = existingImageUrl;
    // You may want to call a VehicleController method to upload and get the URL
    // For now, just ignore image upload logic

    final vehicle = Vehicle(
      vehicleId: widget.vehicle?.vehicleId ?? UniqueKey().toString(),
      ownerName: user.name,
      vehicleName: nameController.text,
      vehicleNumber: numberController.text,
      vehicleYear: yearController.text,
      createdAt: widget.vehicle?.createdAt ?? DateTime.now(),
      uploadedAt: null,
      insuranceStarts: insuranceStart,
      insuranceEnds: insuranceEnd,
      pollutionStarts: pollutionStart,
      pollutionEnds: pollutionEnd,
      battery: batteryController.text,
      alignment: alignmentController.text,
      serviceKm: serviceKmController.text,
      notes: notesController.text,
      needNotification: needNotification,
      sharedWith: sharedWith,
      imageUrl: imageUrl ?? '',
      userAuthUuid: user.authUuid,
      vehicleAddedBy: user.email,
    );
    widget.onSubmit(vehicle);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.vehicle == null ? 'Vehicle added!' : 'Vehicle updated!',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image section
            Center(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: imageFile != null
                        ? Image.file(
                            imageFile!,
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          )
                        : (existingImageUrl != null &&
                              existingImageUrl!.isNotEmpty)
                        ? Image.network(
                            existingImageUrl!,
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 150,
                                width: 150,
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.broken_image, size: 40),
                              );
                            },
                          )
                        : Container(
                            height: 150,
                            width: 150,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.directions_car, size: 50),
                          ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: FloatingActionButton.small(
                      heroTag: 'pickImage',
                      onPressed: _pickImage,
                      child: const Icon(Icons.camera_alt),
                    ),
                  ),
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
            AppInput(
              controller: batteryController,
              label: 'Battery (Optional)',
            ),
            const SizedBox(height: 12),
            AppInput(
              controller: alignmentController,
              label: 'Alignment (Optional)',
            ),
            const SizedBox(height: 12),
            AppInput(controller: notesController, label: 'Notes (Optional)'),
            const SizedBox(height: 12),
            DatePicker(
              label: 'Insurance Start',
              initialDate: insuranceStart,
              onDateSelected: (date) => setState(() => insuranceStart = date),
            ),
            const SizedBox(height: 12),
            DatePicker(
              label: 'Insurance End',
              initialDate: insuranceEnd,
              onDateSelected: (date) => setState(() => insuranceEnd = date),
            ),
            const SizedBox(height: 12),
            DatePicker(
              label: 'Pollution Start',
              initialDate: pollutionStart,
              onDateSelected: (date) => setState(() => pollutionStart = date),
            ),
            const SizedBox(height: 12),
            DatePicker(
              label: 'Pollution End',
              initialDate: pollutionEnd,
              onDateSelected: (date) => setState(() => pollutionEnd = date),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Need Notifications'),
              value: needNotification,
              onChanged: (val) => setState(() => needNotification = val),
            ),
            SwitchListTile(
              title: const Text('Shared With Others'),
              value: sharedWith,
              onChanged: (val) => setState(() => sharedWith = val),
            ),
            const SizedBox(height: 24),
            AppButton(
              label: widget.vehicle == null ? 'Add Vehicle' : 'Update Vehicle',
              onPressed: widget.loading ? null : _submit,
              loading: widget.loading,
            ),
          ],
        ),
      ),
    );
  }
}
