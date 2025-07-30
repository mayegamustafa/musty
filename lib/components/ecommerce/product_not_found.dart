import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/gen/assets.gen.dart';
import 'package:ready_ecommerce/generated/l10n.dart';

class ProductNotFoundWidget extends StatelessWidget {
  const ProductNotFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Assets.png.searceResult.image(),
          Gap(40.h),
          Text(
            S.of(context).productNotFount,
            style: AppTextStyle(context)
                .subTitle
                .copyWith(color: EcommerceAppColor.gray),
          )
        ],
      ),
    );
  }
}
