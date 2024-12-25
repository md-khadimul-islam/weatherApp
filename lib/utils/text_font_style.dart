import 'dart:ui';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../gen/colors.gen.dart';

class TextFontStyle {
  TextFontStyle._();

  static final headline32w700Inter = GoogleFonts.inter(
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.cffffff,
  );

  static final headline12w400Inter = GoogleFonts.inter(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.cffffff,
  );

  static final headline18w400Inter = GoogleFonts.inter(
    fontSize: 18.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.cffffff,
  );

  static final headline50w400Inter = GoogleFonts.inter(
    fontSize: 50.sp,
    fontWeight: FontWeight.w300,
    color: AppColors.cffffff,
  );
}
