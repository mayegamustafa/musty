// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:ready_ecommerce/models/eCommerce/address/add_address.dart';
import 'package:ready_ecommerce/views/eCommerce/address/layouts/add_update_address_layout.dart';

class AddUpdateAddressView extends StatelessWidget {
  final AddAddress? address;
  const AddUpdateAddressView({
    super.key,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return AddUpdateAddressLayout(
      address: address,
    );
  }
}
