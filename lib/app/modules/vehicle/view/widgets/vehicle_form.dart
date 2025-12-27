import 'package:flutter/material.dart';
import '../../../../data/models/vehicle_model.dart';
import '../../../../widgets/app_input.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/date_picker.dart';
import '../../../../utils/validators.dart';

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
  DateTime? insuranceStart;
  DateTime? insuranceEnd;
  DateTime? pollutionStart;
  DateTime? pollutionEnd;

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
    insuranceStart = widget.vehicle?.insuranceStarts;
    insuranceEnd = widget.vehicle?.insuranceEnds;
    pollutionStart = widget.vehicle?.pollutionStarts;
    pollutionEnd = widget.vehicle?.pollutionEnds;
  }

  @override
  void dispose() {
    nameController.dispose();
    numberController.dispose();
    yearController.dispose();
    serviceKmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final vehicle = Vehicle(
        vehicleId: widget.vehicle?.vehicleId ?? UniqueKey().toString(),
        ownerName: '',
        vehicleName: nameController.text,
        vehicleNumber: numberController.text,
        vehicleYear: yearController.text,
        createdAt: DateTime.now(),
        uploadedAt: null,
        insuranceStarts: insuranceStart,
        insuranceEnds: insuranceEnd,
        pollutionStarts: pollutionStart,
        pollutionEnds: pollutionEnd,
        battery: '',
        alignment: '',
        serviceKm: serviceKmController.text,
        notes: '',
        needNotification: false,
        sharedWith: false,
        imageUrl: '',
        userAuthUuid: '',
        vehicleAddedBy: '',
      );
      widget.onSubmit(vehicle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
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
          const SizedBox(height: 24),
          AppButton(
            label: widget.vehicle == null ? 'Add Vehicle' : 'Update Vehicle',
            onPressed: widget.loading ? null : _submit,
            loading: widget.loading,
          ),
        ],
      ),
    );
  }
}
