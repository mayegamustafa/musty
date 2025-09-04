// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/components/ecommerce/custom_button.dart';
import 'package:ready_ecommerce/components/ecommerce/custom_text_field.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/controllers/common/master_controller.dart';
import 'package:ready_ecommerce/controllers/eCommerce/address/address_controller.dart';
import 'package:ready_ecommerce/generated/l10n.dart';
import 'package:ready_ecommerce/models/eCommerce/address/add_address.dart';
import 'package:ready_ecommerce/utils/context_less_navigation.dart';
import 'package:ready_ecommerce/utils/global_function.dart';
import 'package:geolocator/geolocator.dart';

class AddUpdateAddressLayout extends ConsumerStatefulWidget {
  final AddAddress? address;
  const AddUpdateAddressLayout({
    super.key,
    required this.address,
  });

  @override
  ConsumerState<AddUpdateAddressLayout> createState() =>
      _AddUpdateAddressLayoutState();
}

class _AddUpdateAddressLayoutState
    extends ConsumerState<AddUpdateAddressLayout> {
  /// Form key
  final _formKey = GlobalKey<FormState>();

  /// Controllers
  late final TextEditingController addressLine1Controller;
  late final TextEditingController addressLine2Controller;

  /// State variables
  int activeIndex = 0;
  String addressTag = '';

  /// Available tags
  final List<String> addressTags = ["HOME", "OFFICE", "OTHER"];

  @override
  void initState() {
    super.initState();
    addressLine1Controller =
        TextEditingController(text: widget.address?.line1 ?? '');
    addressLine2Controller =
        TextEditingController(text: widget.address?.line2 ?? '');
    addressTag = widget.address?.tag ?? addressTags.first;
    activeIndex = addressTags.indexOf(addressTag);
    if (activeIndex == -1) activeIndex = 0;
  }

  @override
  void dispose() {
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    super.dispose();
  }

  /// Translate tag
  String getTagTranslation({
    required String tag,
    required BuildContext context,
  }) {
    switch (tag.toUpperCase()) {
      case 'HOME':
        return S.of(context).home;
      case 'OFFICE':
        return S.of(context).office;
      default:
        return S.of(context).other;
    }
  }

  /// Address tag widget
  Widget buildAddressTag(BuildContext context) {
    final textStyle = AppTextStyle(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).addressTag,
          style: textStyle.bodyTextSmall.copyWith(fontWeight: FontWeight.w500),
        ),
        Gap(14.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: addressTags.asMap().entries.map(
            (entry) {
              int index = entry.key;
              String tag = entry.value;

              return InkWell(
                borderRadius: BorderRadius.circular(8.sp),
                onTap: () {
                  setState(() {
                    activeIndex = index;
                    addressTag = tag;
                  });
                },
                child: Container(
                  height: 50.h,
                  width: 110.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.sp),
                    border: Border.all(
                      color: activeIndex == index
                          ? colors(context).primaryColor ??
                              EcommerceAppColor.primary
                          : colors(context).bodyTextColor!.withOpacity(0.5),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      getTagTranslation(tag: tag, context: context),
                      style: textStyle.bodyTextSmall.copyWith(
                        color: activeIndex == index
                            ? colors(context).primaryColor ??
                                EcommerceAppColor.primary
                            : colors(context).bodyTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ],
    );
  }

  /// Location fetcher
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      addressLine1Controller.text =
          'Lat: ${position.latitude}, Lng: ${position.longitude}';
    });
  }

  /// Save / Update handler
  void _saveAddress(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final newAddress = AddAddress(
        line1: addressLine1Controller.text.trim(),
        line2: addressLine2Controller.text.trim(),
        tag: addressTag,
      );

      ref.read(addressControllerProvider.notifier).addOrUpdateAddress(newAddress);

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTextStyle(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.address == null
              ? S.of(context).addAddress
              : S.of(context).updateAddress,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAddressTag(context),
              Gap(20.h),

              /// Address Line 1
              CustomTextField(
                controller: addressLine1Controller,
                labelText: S.of(context).addressLine1,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return S.of(context).fieldRequired;
                  }
                  return null;
                },
              ),
              Gap(16.h),

              /// Address Line 2
              CustomTextField(
                controller: addressLine2Controller,
                labelText: S.of(context).addressLine2,
              ),
              Gap(16.h),

              /// Get Current Location Button
              CustomButton(
                label: S.of(context).useCurrentLocation,
                onPressed: _getCurrentLocation,
              ),
              Gap(20.h),

              /// Save Button
              CustomButton(
                label: widget.address == null
                    ? S.of(context).save
                    : S.of(context).update,
                onPressed: () => _saveAddress(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
