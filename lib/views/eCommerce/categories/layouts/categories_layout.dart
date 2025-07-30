import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/controllers/eCommerce/category/category_controller.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/utils/context_less_navigation.dart';
import 'package:ready_ecommerce/utils/global_function.dart';
import 'package:ready_ecommerce/views/eCommerce/categories/components/sub_categories_bottom_sheet.dart';
import 'package:ready_ecommerce/views/eCommerce/home/components/category_card.dart';
import 'package:ready_ecommerce/views/eCommerce/products/layouts/product_details_layout.dart';

class EcommerceCategoriesLayout extends ConsumerWidget {
  const EcommerceCategoriesLayout({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int columnCount = 4;
    bool isDark =
        Theme.of(context).scaffoldBackgroundColor == EcommerceAppColor.black;
    return LoadingWrapperWidget(
      isLoading: ref.watch(subCategoryControllerProvider),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('All Categories'),
          toolbarHeight: 80.h,
        ),
        backgroundColor:
            isDark ? EcommerceAppColor.black : EcommerceAppColor.offWhite,
        body: Consumer(
          builder: (context, ref, _) {
            final asyncValue = ref.watch(categoryControllerProvider);
            return asyncValue.when(
              data: (categoryList) => AnimationLimiter(
                child: RefreshIndicator(
                  onRefresh: () async {
                    ref.refresh(categoryControllerProvider).value;
                  },
                  child: GridView.builder(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 15.h,
                      crossAxisSpacing: 0.w,
                      childAspectRatio: 90.w / 105.w,
                      crossAxisCount: columnCount,
                    ),
                    itemCount: categoryList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        columnCount: columnCount,
                        child: ScaleAnimation(
                          child: FadeInAnimation(
                            child: CategoryCard(
                                category: categoryList[index],
                                // TODO need to work here
                                onTap: () {
                                  if (categoryList[index]
                                      .subCategories
                                      .isNotEmpty) {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) =>
                                          SubCategoriesBottomSheet(
                                        category: categoryList[index],
                                      ),
                                    );
                                  } else {
                                    GlobalFunction
                                        .navigatorKey.currentContext!.nav
                                        .pushNamed(
                                      Routes.getProductsViewRouteName(
                                        AppConstants.appServiceName,
                                      ),
                                      arguments: [
                                        categoryList[index].id,
                                        categoryList[index].name,
                                        null,
                                        null,
                                        null,
                                        categoryList[index].subCategories,
                                      ],
                                    );
                                  }
                                }),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              error: (error, stackTrace) => Center(
                child: Text(
                  error.toString(),
                ),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ),
    );
  }
}
