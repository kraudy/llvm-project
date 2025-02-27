; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s
;
; This test makes sure that InstCombine does not replace the sequence of
; xor/sub instruction followed by cmp instruction into a single cmp instruction
; if there is more than one use of xor/sub.

define zeroext i1 @test1(i32 %lhs, i32 %rhs) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[LHS:%.*]], 5
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i32 [[XOR]], 10
; CHECK-NEXT:    [[CMP2:%.*]] = icmp eq i32 [[XOR]], [[RHS:%.*]]
; CHECK-NEXT:    [[SEL:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[SEL]]
;

  %xor = xor i32 %lhs, 5
  %cmp1 = icmp eq i32 %xor, 10
  %cmp2 = icmp eq i32 %xor, %rhs
  %sel = or i1 %cmp1, %cmp2
  ret i1 %sel
}

define zeroext i1 @test1_logical(i32 %lhs, i32 %rhs) {
; CHECK-LABEL: @test1_logical(
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[LHS:%.*]], 5
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i32 [[XOR]], 10
; CHECK-NEXT:    [[CMP2:%.*]] = icmp eq i32 [[XOR]], [[RHS:%.*]]
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[CMP1]], i1 true, i1 [[CMP2]]
; CHECK-NEXT:    ret i1 [[SEL]]
;

  %xor = xor i32 %lhs, 5
  %cmp1 = icmp eq i32 %xor, 10
  %cmp2 = icmp eq i32 %xor, %rhs
  %sel = select i1 %cmp1, i1 true, i1 %cmp2
  ret i1 %sel
}

define zeroext i1 @test2(i32 %lhs, i32 %rhs) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[LHS:%.*]], [[RHS:%.*]]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i32 [[XOR]], 0
; CHECK-NEXT:    [[CMP2:%.*]] = icmp eq i32 [[XOR]], 32
; CHECK-NEXT:    [[SEL:%.*]] = xor i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[SEL]]
;

  %xor = xor i32 %lhs, %rhs
  %cmp1 = icmp eq i32 %xor, 0
  %cmp2 = icmp eq i32 %xor, 32
  %sel = xor i1 %cmp1, %cmp2
  ret i1 %sel
}

define zeroext i1 @test3(i32 %lhs, i32 %rhs) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[SUB:%.*]] = sub nsw i32 [[LHS:%.*]], [[RHS:%.*]]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i32 [[LHS]], [[RHS]]
; CHECK-NEXT:    [[CMP2:%.*]] = icmp eq i32 [[SUB]], 31
; CHECK-NEXT:    [[SEL:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[SEL]]
;

  %sub = sub nsw i32 %lhs, %rhs
  %cmp1 = icmp eq i32 %sub, 0
  %cmp2 = icmp eq i32 %sub, 31
  %sel = or i1 %cmp1, %cmp2
  ret i1 %sel
}

define zeroext i1 @test3_logical(i32 %lhs, i32 %rhs) {
; CHECK-LABEL: @test3_logical(
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 [[LHS:%.*]], [[RHS:%.*]]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i32 [[LHS]], [[RHS]]
; CHECK-NEXT:    [[CMP2:%.*]] = icmp eq i32 [[SUB]], 31
; CHECK-NEXT:    [[SEL:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[SEL]]
;

  %sub = sub nsw i32 %lhs, %rhs
  %cmp1 = icmp eq i32 %sub, 0
  %cmp2 = icmp eq i32 %sub, 31
  %sel = select i1 %cmp1, i1 true, i1 %cmp2
  ret i1 %sel
}
