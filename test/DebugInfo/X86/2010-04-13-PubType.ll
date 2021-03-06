; RUN: llc -O0 -asm-verbose -mtriple=x86_64-macosx -generate-dwarf-pub-sections=Enable < %s | FileCheck %s
; CHECK-NOT: .asciz "X" ## External Name
; CHECK: .asciz "Y" ## External Name
; Test to check type with no definition is listed in pubtypes section.
%struct.X = type opaque
%struct.Y = type { i32 }

define i32 @foo(%struct.X* %x, %struct.Y* %y) nounwind ssp {
entry:
  %x_addr = alloca %struct.X*                     ; <%struct.X**> [#uses=1]
  %y_addr = alloca %struct.Y*                     ; <%struct.Y**> [#uses=1]
  %retval = alloca i32                            ; <i32*> [#uses=2]
  %0 = alloca i32                                 ; <i32*> [#uses=2]
  %"alloca point" = bitcast i32 0 to i32          ; <i32> [#uses=0]
  call void @llvm.dbg.declare(metadata %struct.X** %x_addr, metadata !0, metadata !MDExpression()), !dbg !13
  store %struct.X* %x, %struct.X** %x_addr
  call void @llvm.dbg.declare(metadata %struct.Y** %y_addr, metadata !14, metadata !MDExpression()), !dbg !13
  store %struct.Y* %y, %struct.Y** %y_addr
  store i32 0, i32* %0, align 4, !dbg !13
  %1 = load i32, i32* %0, align 4, !dbg !13            ; <i32> [#uses=1]
  store i32 %1, i32* %retval, align 4, !dbg !13
  br label %return, !dbg !13

return:                                           ; preds = %entry
  %retval1 = load i32, i32* %retval, !dbg !13          ; <i32> [#uses=1]
  ret i32 %retval1, !dbg !15
}

declare void @llvm.dbg.declare(metadata, metadata, metadata) nounwind readnone

!llvm.dbg.cu = !{!3}
!llvm.module.flags = !{!20}

!0 = !MDLocalVariable(tag: DW_TAG_arg_variable, name: "x", line: 7, arg: 0, scope: !1, file: !2, type: !7)
!1 = !MDSubprogram(name: "foo", linkageName: "foo", line: 7, isLocal: false, isDefinition: true, virtualIndex: 6, isOptimized: false, scopeLine: 7, file: !18, scope: !2, type: !4, function: i32 (%struct.X*, %struct.Y*)* @foo)
!2 = !MDFile(filename: "a.c", directory: "/tmp/")
!3 = !MDCompileUnit(language: DW_LANG_C89, producer: "4.2.1 (Based on Apple Inc. build 5658) (LLVM build)", isOptimized: false, emissionKind: 0, file: !18, enums: !19, retainedTypes: !19, subprograms: !17, imports:  null)
!4 = !MDSubroutineType(types: !5)
!5 = !{!6, !7, !9}
!6 = !MDBasicType(tag: DW_TAG_base_type, name: "int", size: 32, align: 32, encoding: DW_ATE_signed)
!7 = !MDDerivedType(tag: DW_TAG_pointer_type, size: 64, align: 64, file: !18, scope: !2, baseType: !8)
!8 = !MDCompositeType(tag: DW_TAG_structure_type, name: "X", line: 3, flags: DIFlagFwdDecl, file: !18, scope: !2)
!9 = !MDDerivedType(tag: DW_TAG_pointer_type, size: 64, align: 64, file: !18, scope: !2, baseType: !10)
!10 = !MDCompositeType(tag: DW_TAG_structure_type, name: "Y", line: 4, size: 32, align: 32, file: !18, scope: !2, elements: !11)
!11 = !{!12}
!12 = !MDDerivedType(tag: DW_TAG_member, name: "x", line: 5, size: 32, align: 32, file: !18, scope: !10, baseType: !6)
!13 = !MDLocation(line: 7, scope: !1)
!14 = !MDLocalVariable(tag: DW_TAG_arg_variable, name: "y", line: 7, arg: 0, scope: !1, file: !2, type: !9)
!15 = !MDLocation(line: 7, scope: !16)
!16 = distinct !MDLexicalBlock(line: 7, column: 0, file: !18, scope: !1)
!17 = !{!1}
!18 = !MDFile(filename: "a.c", directory: "/tmp/")
!19 = !{}
!20 = !{i32 1, !"Debug Info Version", i32 3}
