﻿; +--------------+
; | RegEx_Helper |
; +--------------+
; | 2018-06-22 : Creation

;   \s = whitespace characters (\S = NOT whitespace characters)
;   \w = word characters (\W = NOT word characters)
;
;   * = 0 or more (greedy, as much as possible)
;   + = 1 or more (greedy, as much as possible)
;   *? = 0 or more (lazy, as little as possible)
;   +? = 1 or more (lazy, as little as possible)
;
;   ^ = start of string/line
;   $ = end of string/line

;-
CompilerIf (Not Defined(_RegEx_Helper_Included, #PB_Constant))
#_RegEx_Helper_Included = #True

CompilerIf (#PB_Compiler_IsMainFile)
  EnableExplicit
CompilerEndIf

;- Procedures

Procedure.s ReReplace(String.s, Pattern.s, Replacement.s, Flags.i = #Null)
  Protected Result.s
  Protected *RE = CreateRegularExpression(#PB_Any, Pattern, Flags)
  If (*RE)
    Result = ReplaceRegularExpression(*RE, String, Replacement)
    FreeRegularExpression(*RE)
  EndIf
  ProcedureReturn (Result)
EndProcedure

Procedure.s ReRemove(String.s, Pattern.s, Flags.i = #Null)
  ProcedureReturn (ReReplace(String, Pattern, "", Flags))
EndProcedure

Procedure.i ReMatch(String.s, Pattern.s, Flags.i = #Null)
  Protected Result.i = #False
  Protected *RE = CreateRegularExpression(#PB_Any, Pattern, Flags)
  If (*RE)
    Result = MatchRegularExpression(*RE, String)
    FreeRegularExpression(*RE)
  EndIf
  ProcedureReturn (Result)
EndProcedure

Procedure.i ReExtractArray(String.s, Pattern.s, Array Match.s(1), Flags.i = #Null)
  Protected Result.i = 0
  Dim Match.s(0)
  Protected *RE = CreateRegularExpression(#PB_Any, Pattern, Flags)
  If (*RE)
    Result = ExtractRegularExpression(*RE, String, Match())
    FreeRegularExpression(*RE)
  EndIf
  ProcedureReturn (Result)
EndProcedure

Procedure.i ReExtractList(String.s, Pattern.s, List Match.s(), Flags.i = #Null)
  Protected Result.i
  Dim AMatch.s(0)
  Result = ReExtractArray(String, Pattern, AMatch(), Flags)
  ClearList(Match())
  If (Result > 0)
    Protected i.i
    For i = 0 To Result-1
      AddElement(Match())
      Match() = AMatch(i)
    Next i
  EndIf
  ProcedureReturn (Result)
EndProcedure

;- ReQuickResult
Threaded NewList ReQuickResult.s()

Procedure.i ReQuickExtract(String.s, Pattern.s, Flags.i = #Null)
  ProcedureReturn (ReExtractList(String, Pattern, ReQuickResult(), Flags))
EndProcedure




;-
;- Demo

CompilerIf (#PB_Compiler_IsMainFile)
DisableExplicit

Debug ReReplace("Hello World!", "\s+", "___")

Debug ReRemove("Hello World!", "l")

Debug ReMatch("Hello World!", "^[GHI].*\W$")

Debug ""
Debug ReQuickExtract("Hello World!", "[a-z]+")
ForEach ReQuickResult()
  Debug ReQuickResult()
Next

CompilerEndIf
CompilerEndIf
;-