; RUN: llc < %s -march=mips -mcpu=mips2 -relocation-model=pic | FileCheck %s \
; RUN:    -check-prefix=ALL -check-prefix=GP32 \
; RUN:    -check-prefix=NOT-R6 -check-prefix=NOT-R2-R6
; RUN: llc < %s -march=mips -mcpu=mips32 -relocation-model=pic | FileCheck %s \
; RUN:    -check-prefix=ALL -check-prefix=GP32 \
; RUN:    -check-prefix=NOT-R6 -check-prefix=NOT-R2-R6
; RUN: llc < %s -march=mips -mcpu=mips32r2 -relocation-model=pic | FileCheck %s \
; RUN:    -check-prefix=ALL -check-prefix=GP32 -check-prefix=R2-R5 \
; RUN:    -check-prefix=R2-R6 -check-prefix=NOT-R6
; RUN: llc < %s -march=mips -mcpu=mips32r3 -relocation-model=pic | FileCheck %s \
; RUN:    -check-prefix=ALL -check-prefix=GP32 -check-prefix=R2-R5 \
; RUN:    -check-prefix=R2-R6 -check-prefix=NOT-R6
; RUN: llc < %s -march=mips -mcpu=mips32r5 -relocation-model=pic | FileCheck %s \
; RUN:    -check-prefix=ALL -check-prefix=GP32 -check-prefix=R2-R5 \
; RUN:    -check-prefix=R2-R6 -check-prefix=NOT-R6
; RUN: llc < %s -march=mips -mcpu=mips32r6 -relocation-model=pic | FileCheck %s \
; RUN:    -check-prefix=ALL -check-prefix=GP32 \
; RUN:    -check-prefix=R6 -check-prefix=R2-R6

; RUN: llc < %s -march=mips64 -mcpu=mips3 -relocation-model=pic | FileCheck %s \
; RUN:    -check-prefix=ALL -check-prefix=GP64-NOT-R6 \
; RUN:    -check-prefix=NOT-R6 -check-prefix=NOT-R2-R6
; RUN: llc < %s -march=mips64 -mcpu=mips4 -relocation-model=pic | FileCheck %s \
; RUN:    -check-prefix=ALL -check-prefix=GP64-NOT-R6 \
; RUN:    -check-prefix=NOT-R6 -check-prefix=NOT-R2-R6
; RUN: llc < %s -march=mips64 -mcpu=mips64 -relocation-model=pic | FileCheck %s \
; RUN:    -check-prefix=ALL -check-prefix=GP64-NOT-R6 \
; RUN:    -check-prefix=NOT-R6 -check-prefix=NOT-R2-R6
; RUN: llc < %s -march=mips64 -mcpu=mips64r2 -relocation-model=pic | FileCheck %s \
; RUN:    -check-prefix=ALL -check-prefix=R2-R5 -check-prefix=R2-R6 \
; RUN:    -check-prefix=GP64-NOT-R6 -check-prefix=NOT-R6
; RUN: llc < %s -march=mips64 -mcpu=mips64r3 -relocation-model=pic | FileCheck %s \
; RUN:    -check-prefix=ALL -check-prefix=R2-R5 -check-prefix=R2-R6 \
; RUN:    -check-prefix=GP64-NOT-R6 -check-prefix=NOT-R6
; RUN: llc < %s -march=mips64 -mcpu=mips64r5 -relocation-model=pic | FileCheck %s \
; RUN:    -check-prefix=ALL -check-prefix=R2-R5 -check-prefix=R2-R6 \
; RUN:    -check-prefix=GP64-NOT-R6 -check-prefix=NOT-R6
; RUN: llc < %s -march=mips64 -mcpu=mips64r6 -relocation-model=pic | FileCheck %s \
; RUN:    -check-prefix=ALL -check-prefix=64R6 \
; RUN:    -check-prefix=R6 -check-prefix=R2-R6

; RUN: llc < %s -march=mips -mcpu=mips32r3 -mattr=+micromips -relocation-model=pic | FileCheck %s \
; RUN:    -check-prefix=ALL -check-prefix=MMR3 -check-prefix=MM32
; RUN: llc < %s -march=mips -mcpu=mips32r6 -mattr=+micromips -relocation-model=pic | FileCheck %s \
; RUN:    -check-prefix=ALL -check-prefix=MMR6 -check-prefix=MM32
; RUN: llc < %s -march=mips -mcpu=mips64r6 -mattr=+micromips -relocation-model=pic | FileCheck %s \
; RUN:    -check-prefix=ALL -check-prefix=MMR6 -check-prefix=MM64

define signext i1 @urem_i1(i1 signext %a, i1 signext %b) {
entry:
; ALL-LABEL: urem_i1:

  ; NOT-R6:       andi    $[[T0:[0-9]+]], $5, 1
  ; NOT-R6:       andi    $[[T1:[0-9]+]], $4, 1
  ; NOT-R6:       divu    $zero, $[[T1]], $[[T0]]
  ; NOT-R6:       teq     $[[T0]], $zero, 7
  ; NOT-R6:       mfhi    $[[T2:[0-9]+]]
  ; NOT-R6:       sll     $[[T3:[0-9]+]], $[[T2]], 31
  ; NOT-R6:       sra     $2, $[[T3]], 31

  ; R6:           andi    $[[T0:[0-9]+]], $5, 1
  ; R6:           andi    $[[T1:[0-9]+]], $4, 1
  ; R6:           modu    $[[T2:[0-9]+]], $[[T1]], $[[T0]]
  ; R6:           teq     $[[T0]], $zero, 7
  ; R6:           sll     $[[T3:[0-9]+]], $[[T2]], 31
  ; R6:           sra     $2, $[[T3]], 31

  ; MMR3:         andi16  $[[T0:[0-9]+]], $5, 1
  ; MMR3:         andi16  $[[T1:[0-9]+]], $4, 1
  ; MMR3:         divu    $zero, $[[T1]], $[[T0]]
  ; MMR3:         teq     $[[T0]], $zero, 7
  ; MMR3:         mfhi    $[[T2:[0-9]+]]
  ; MMR3:         sll     $[[T3:[0-9]+]], $[[T2]], 31
  ; MMR3:         sra     $2, $[[T3]], 31

  ; MMR6:         andi16  $[[T0:[0-9]+]], $5, 1
  ; MMR6:         andi16  $[[T1:[0-9]+]], $4, 1
  ; MMR6:         modu    $[[T2:[0-9]+]], $[[T1]], $[[T0]]
  ; MMR6:         teq     $[[T0]], $zero, 7
  ; MMR6:         sll     $[[T3:[0-9]+]], $[[T2]], 31
  ; MMR6:         sra     $2, $[[T3]], 31

  %r = urem i1 %a, %b
  ret i1 %r
}

define signext i8 @urem_i8(i8 signext %a, i8 signext %b) {
entry:
; ALL-LABEL: urem_i8:

  ; NOT-R2-R6:    andi    $[[T0:[0-9]+]], $5, 255
  ; NOT-R2-R6:    andi    $[[T1:[0-9]+]], $4, 255
  ; NOT-R2-R6:    divu    $zero, $[[T1]], $[[T0]]
  ; NOT-R2-R6:    teq     $[[T0]], $zero, 7
  ; NOT-R2-R6:    mfhi    $[[T2:[0-9]+]]
  ; NOT-R2-R6:    sll     $[[T3:[0-9]+]], $[[T2]], 24
  ; NOT-R2-R6:    sra     $2, $[[T3]], 24

  ; R2-R5:        andi    $[[T0:[0-9]+]], $5, 255
  ; R2-R5:        andi    $[[T1:[0-9]+]], $4, 255
  ; R2-R5:        divu    $zero, $[[T1]], $[[T0]]
  ; R2-R5:        teq     $[[T0]], $zero, 7
  ; R2-R5:        mfhi    $[[T2:[0-9]+]]
  ; R2-R5:        seb     $2, $[[T2]]

  ; R6:           andi    $[[T0:[0-9]+]], $5, 255
  ; R6:           andi    $[[T1:[0-9]+]], $4, 255
  ; R6:           modu    $[[T2:[0-9]+]], $[[T1]], $[[T0]]
  ; R6:           teq     $[[T0]], $zero, 7
  ; R6:           seb     $2, $[[T2]]

  ; MMR3:         andi16  $[[T0:[0-9]+]], $5, 255
  ; MMR3:         andi16  $[[T1:[0-9]+]], $4, 255
  ; MMR3:         divu    $zero, $[[T1]], $[[T0]]
  ; MMR3:         teq     $[[T0]], $zero, 7
  ; MMR3:         mfhi    $[[T2:[0-9]+]]
  ; MMR3:         seb     $2, $[[T2]]

  ; MMR6:         andi16  $[[T0:[0-9]+]], $5, 255
  ; MMR6:         andi16  $[[T1:[0-9]+]], $4, 255
  ; MMR6:         modu    $[[T2:[0-9]+]], $[[T1]], $[[T0]]
  ; MMR6:         teq     $[[T0]], $zero, 7
  ; MMR6:         seb     $2, $[[T2]]

  %r = urem i8 %a, %b
  ret i8 %r
}

define signext i16 @urem_i16(i16 signext %a, i16 signext %b) {
entry:
; ALL-LABEL: urem_i16:

  ; NOT-R2-R6:    andi    $[[T0:[0-9]+]], $5, 65535
  ; NOT-R2-R6:    andi    $[[T1:[0-9]+]], $4, 65535
  ; NOT-R2-R6:    divu    $zero, $[[T1]], $[[T0]]
  ; NOT-R2-R6:    teq     $[[T0]], $zero, 7
  ; NOT-R2-R6:    mfhi    $[[T2:[0-9]+]]
  ; NOT-R2-R6:    sll     $[[T3:[0-9]+]], $[[T2]], 16
  ; NOT-R2-R6:    sra     $2, $[[T3]], 16

  ; R2-R5:        andi    $[[T0:[0-9]+]], $5, 65535
  ; R2-R5:        andi    $[[T1:[0-9]+]], $4, 65535
  ; R2-R5:        divu    $zero, $[[T1]], $[[T0]]
  ; R2-R5:        teq     $[[T0]], $zero, 7
  ; R2-R5:        mfhi    $[[T3:[0-9]+]]
  ; R2-R5:        seh     $2, $[[T2]]

  ; R6:           andi    $[[T0:[0-9]+]], $5, 65535
  ; R6:           andi    $[[T1:[0-9]+]], $4, 65535
  ; R6:           modu    $[[T2:[0-9]+]], $[[T1]], $[[T0]]
  ; R6:           teq     $[[T0]], $zero, 7
  ; R6:           seh     $2, $[[T2]]

  ; MMR3:         andi16  $[[T0:[0-9]+]], $5, 65535
  ; MMR3:         andi16  $[[T1:[0-9]+]], $4, 65535
  ; MMR3:         divu    $zero, $[[T1]], $[[T0]]
  ; MMR3:         teq     $[[T0]], $zero, 7
  ; MMR3:         mfhi    $[[T2:[0-9]+]]
  ; MMR3:         seh     $2, $[[T2]]

  ; MMR6:         andi16  $[[T0:[0-9]+]], $5, 65535
  ; MMR6:         andi16  $[[T1:[0-9]+]], $4, 65535
  ; MMR6:         modu    $[[T2:[0-9]+]], $[[T1]], $[[T0]]
  ; MMR6:         teq     $[[T0]], $zero, 7
  ; MMR6:         seh     $2, $[[T2]]

  %r = urem i16 %a, %b
  ret i16 %r
}

define signext i32 @urem_i32(i32 signext %a, i32 signext %b) {
entry:
; ALL-LABEL: urem_i32:

  ; NOT-R6:       divu    $zero, $4, $5
  ; NOT-R6:       teq     $5, $zero, 7
  ; NOT-R6:       mfhi    $2

  ; R6:           modu    $2, $4, $5
  ; R6:           teq     $5, $zero, 7

  ; MMR3:         divu    $zero, $4, $5
  ; MMR3:         teq     $5, $zero, 7
  ; MMR3:         mfhi    $2

  ; MMR6:         modu    $2, $4, $5
  ; MMR6:         teq     $5, $zero, 7

  %r = urem i32 %a, %b
  ret i32 %r
}

define signext i64 @urem_i64(i64 signext %a, i64 signext %b) {
entry:
; ALL-LABEL: urem_i64:

  ; GP32:         lw      $25, %call16(__umoddi3)($gp)

  ; GP64-NOT-R6:  ddivu   $zero, $4, $5
  ; GP64-NOT-R6:  teq     $5, $zero, 7
  ; GP64-NOT-R6:  mfhi    $2

  ; 64R6:         dmodu   $2, $4, $5
  ; 64R6:         teq     $5, $zero, 7

  ; MM32:         lw      $25, %call16(__umoddi3)($2)

  ; MM64:         dmodu   $2, $4, $5
  ; MM64:         teq     $5, $zero, 7

  %r = urem i64 %a, %b
  ret i64 %r
}

define signext i128 @urem_i128(i128 signext %a, i128 signext %b) {
entry:
  ; ALL-LABEL: urem_i128:

  ; GP32:         lw      $25, %call16(__umodti3)($gp)

  ; GP64-NOT-R6:  ld      $25, %call16(__umodti3)($gp)
  ; 64R6:         ld      $25, %call16(__umodti3)($gp)

  ; MM32:         lw      $25, %call16(__umodti3)($2)

  ; MM64:         ld      $25, %call16(__umodti3)($2)

    %r = urem i128 %a, %b
    ret i128 %r
}
