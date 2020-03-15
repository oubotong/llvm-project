// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py
// RUN: %clang_cc1 -triple thumbv8.1m.main-arm-none-eabi -target-feature +mve.fp -mfloat-abi hard -fallow-half-arguments-and-returns -O0 -disable-O0-optnone -S -emit-llvm -o - %s | opt -S -sroa | FileCheck %s
// RUN: %clang_cc1 -triple thumbv8.1m.main-arm-none-eabi -target-feature +mve.fp -mfloat-abi hard -fallow-half-arguments-and-returns -O0 -disable-O0-optnone -DPOLYMORPHIC -S -emit-llvm -o - %s | opt -S -sroa | FileCheck %s

#include <arm_mve.h>

// CHECK-LABEL: @test_vsubq_u32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = sub <4 x i32> [[A:%.*]], [[B:%.*]]
// CHECK-NEXT:    ret <4 x i32> [[TMP0]]
//
uint32x4_t test_vsubq_u32(uint32x4_t a, uint32x4_t b)
{
#ifdef POLYMORPHIC
    return vsubq(a, b);
#else /* POLYMORPHIC */
    return vsubq_u32(a, b);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vsubq_f16(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = fsub <8 x half> [[A:%.*]], [[B:%.*]]
// CHECK-NEXT:    ret <8 x half> [[TMP0]]
//
float16x8_t test_vsubq_f16(float16x8_t a, float16x8_t b)
{
#ifdef POLYMORPHIC
    return vsubq(a, b);
#else /* POLYMORPHIC */
    return vsubq_f16(a, b);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vsubq_m_s8(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call <16 x i8> @llvm.arm.mve.sub.predicated.v16i8.v16i1(<16 x i8> [[A:%.*]], <16 x i8> [[B:%.*]], <16 x i1> [[TMP1]], <16 x i8> [[INACTIVE:%.*]])
// CHECK-NEXT:    ret <16 x i8> [[TMP2]]
//
int8x16_t test_vsubq_m_s8(int8x16_t inactive, int8x16_t a, int8x16_t b, mve_pred16_t p)
{
#ifdef POLYMORPHIC
    return vsubq_m(inactive, a, b, p);
#else /* POLYMORPHIC */
    return vsubq_m_s8(inactive, a, b, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vsubq_m_f32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call <4 x float> @llvm.arm.mve.sub.predicated.v4f32.v4i1(<4 x float> [[A:%.*]], <4 x float> [[B:%.*]], <4 x i1> [[TMP1]], <4 x float> [[INACTIVE:%.*]])
// CHECK-NEXT:    ret <4 x float> [[TMP2]]
//
float32x4_t test_vsubq_m_f32(float32x4_t inactive, float32x4_t a, float32x4_t b, mve_pred16_t p)
{
#ifdef POLYMORPHIC
    return vsubq_m(inactive, a, b, p);
#else /* POLYMORPHIC */
    return vsubq_m_f32(inactive, a, b, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vsubq_x_u16(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call <8 x i16> @llvm.arm.mve.sub.predicated.v8i16.v8i1(<8 x i16> [[A:%.*]], <8 x i16> [[B:%.*]], <8 x i1> [[TMP1]], <8 x i16> undef)
// CHECK-NEXT:    ret <8 x i16> [[TMP2]]
//
uint16x8_t test_vsubq_x_u16(uint16x8_t a, uint16x8_t b, mve_pred16_t p)
{
#ifdef POLYMORPHIC
    return vsubq_x(a, b, p);
#else /* POLYMORPHIC */
    return vsubq_x_u16(a, b, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vsubq_x_f16(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call <8 x half> @llvm.arm.mve.sub.predicated.v8f16.v8i1(<8 x half> [[A:%.*]], <8 x half> [[B:%.*]], <8 x i1> [[TMP1]], <8 x half> undef)
// CHECK-NEXT:    ret <8 x half> [[TMP2]]
//
float16x8_t test_vsubq_x_f16(float16x8_t a, float16x8_t b, mve_pred16_t p)
{
#ifdef POLYMORPHIC
    return vsubq_x(a, b, p);
#else /* POLYMORPHIC */
    return vsubq_x_f16(a, b, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vsubq_n_u32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[DOTSPLATINSERT:%.*]] = insertelement <4 x i32> undef, i32 [[B:%.*]], i32 0
// CHECK-NEXT:    [[DOTSPLAT:%.*]] = shufflevector <4 x i32> [[DOTSPLATINSERT]], <4 x i32> undef, <4 x i32> zeroinitializer
// CHECK-NEXT:    [[TMP0:%.*]] = sub <4 x i32> [[A:%.*]], [[DOTSPLAT]]
// CHECK-NEXT:    ret <4 x i32> [[TMP0]]
//
uint32x4_t test_vsubq_n_u32(uint32x4_t a, uint32_t b)
{
#ifdef POLYMORPHIC
    return vsubq(a, b);
#else /* POLYMORPHIC */
    return vsubq_n_u32(a, b);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vsubq_n_f16(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = bitcast float [[B_COERCE:%.*]] to i32
// CHECK-NEXT:    [[TMP_0_EXTRACT_TRUNC:%.*]] = trunc i32 [[TMP0]] to i16
// CHECK-NEXT:    [[TMP1:%.*]] = bitcast i16 [[TMP_0_EXTRACT_TRUNC]] to half
// CHECK-NEXT:    [[DOTSPLATINSERT:%.*]] = insertelement <8 x half> undef, half [[TMP1]], i32 0
// CHECK-NEXT:    [[DOTSPLAT:%.*]] = shufflevector <8 x half> [[DOTSPLATINSERT]], <8 x half> undef, <8 x i32> zeroinitializer
// CHECK-NEXT:    [[TMP2:%.*]] = fsub <8 x half> [[A:%.*]], [[DOTSPLAT]]
// CHECK-NEXT:    ret <8 x half> [[TMP2]]
//
float16x8_t test_vsubq_n_f16(float16x8_t a, float16_t b)
{
#ifdef POLYMORPHIC
    return vsubq(a, b);
#else /* POLYMORPHIC */
    return vsubq_n_f16(a, b);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vsubq_m_n_s8(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[DOTSPLATINSERT:%.*]] = insertelement <16 x i8> undef, i8 [[B:%.*]], i32 0
// CHECK-NEXT:    [[DOTSPLAT:%.*]] = shufflevector <16 x i8> [[DOTSPLATINSERT]], <16 x i8> undef, <16 x i32> zeroinitializer
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call <16 x i8> @llvm.arm.mve.sub.predicated.v16i8.v16i1(<16 x i8> [[A:%.*]], <16 x i8> [[DOTSPLAT]], <16 x i1> [[TMP1]], <16 x i8> [[INACTIVE:%.*]])
// CHECK-NEXT:    ret <16 x i8> [[TMP2]]
//
int8x16_t test_vsubq_m_n_s8(int8x16_t inactive, int8x16_t a, int8_t b, mve_pred16_t p)
{
#ifdef POLYMORPHIC
    return vsubq_m(inactive, a, b, p);
#else /* POLYMORPHIC */
    return vsubq_m_n_s8(inactive, a, b, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vsubq_m_n_f32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[DOTSPLATINSERT:%.*]] = insertelement <4 x float> undef, float [[B:%.*]], i32 0
// CHECK-NEXT:    [[DOTSPLAT:%.*]] = shufflevector <4 x float> [[DOTSPLATINSERT]], <4 x float> undef, <4 x i32> zeroinitializer
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call <4 x float> @llvm.arm.mve.sub.predicated.v4f32.v4i1(<4 x float> [[A:%.*]], <4 x float> [[DOTSPLAT]], <4 x i1> [[TMP1]], <4 x float> [[INACTIVE:%.*]])
// CHECK-NEXT:    ret <4 x float> [[TMP2]]
//
float32x4_t test_vsubq_m_n_f32(float32x4_t inactive, float32x4_t a, float32_t b, mve_pred16_t p)
{
#ifdef POLYMORPHIC
    return vsubq_m(inactive, a, b, p);
#else /* POLYMORPHIC */
    return vsubq_m_n_f32(inactive, a, b, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vsubq_x_n_u16(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[DOTSPLATINSERT:%.*]] = insertelement <8 x i16> undef, i16 [[B:%.*]], i32 0
// CHECK-NEXT:    [[DOTSPLAT:%.*]] = shufflevector <8 x i16> [[DOTSPLATINSERT]], <8 x i16> undef, <8 x i32> zeroinitializer
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call <8 x i16> @llvm.arm.mve.sub.predicated.v8i16.v8i1(<8 x i16> [[A:%.*]], <8 x i16> [[DOTSPLAT]], <8 x i1> [[TMP1]], <8 x i16> undef)
// CHECK-NEXT:    ret <8 x i16> [[TMP2]]
//
uint16x8_t test_vsubq_x_n_u16(uint16x8_t a, uint16_t b, mve_pred16_t p)
{
#ifdef POLYMORPHIC
    return vsubq_x(a, b, p);
#else /* POLYMORPHIC */
    return vsubq_x_n_u16(a, b, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vsubq_x_n_f16(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = bitcast float [[B_COERCE:%.*]] to i32
// CHECK-NEXT:    [[TMP_0_EXTRACT_TRUNC:%.*]] = trunc i32 [[TMP0]] to i16
// CHECK-NEXT:    [[TMP1:%.*]] = bitcast i16 [[TMP_0_EXTRACT_TRUNC]] to half
// CHECK-NEXT:    [[DOTSPLATINSERT:%.*]] = insertelement <8 x half> undef, half [[TMP1]], i32 0
// CHECK-NEXT:    [[DOTSPLAT:%.*]] = shufflevector <8 x half> [[DOTSPLATINSERT]], <8 x half> undef, <8 x i32> zeroinitializer
// CHECK-NEXT:    [[TMP2:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP3:%.*]] = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 [[TMP2]])
// CHECK-NEXT:    [[TMP4:%.*]] = call <8 x half> @llvm.arm.mve.sub.predicated.v8f16.v8i1(<8 x half> [[A:%.*]], <8 x half> [[DOTSPLAT]], <8 x i1> [[TMP3]], <8 x half> undef)
// CHECK-NEXT:    ret <8 x half> [[TMP4]]
//
float16x8_t test_vsubq_x_n_f16(float16x8_t a, float16_t b, mve_pred16_t p)
{
#ifdef POLYMORPHIC
    return vsubq_x(a, b, p);
#else /* POLYMORPHIC */
    return vsubq_x_n_f16(a, b, p);
#endif /* POLYMORPHIC */
}
