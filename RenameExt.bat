@echo off
setlocal enableDelayedExpansion

set "thisDir=%~dp0"

:main

cls
echo # Rename - by CorpNewt #
echo.
echo Hey scrub, hit me with a path to search through:
echo (eave blank for the current script directory)
set /p "path="

if "!path!"=="" (
	set "path=!thisDir!"
) else (
	if NOT EXIST "%path%" (
		cls
		echo ### WARNING ###
		echo.
		echo "%path%" does not exist.
		echo Press [enter] to return to path selection...
		echo.
		pause > nul
		goto main
	)
)

REM We have a valid path
goto getExt

:getExt
cls
echo # Rename - by CorpNewt #
echo.
echo Current Path: !path!
echo.
echo Sweet - now I need the extension to search for [ex. .jpg]:
set /p "lookExt="

if "!lookExt!"=="" (
	goto getExt
)

REM We have an extension to search for
goto getRep

:getRep
cls
echo # Rename - by CorpNewt #
echo.
echo Current Path: !path!
echo Target Extension: !lookExt!
echo.
echo Sweet - now I need the extension to replace with [ex. .jpeg]:
set /p "repExt="

if "!repExt!"=="" (
	goto getRep
)

REM We have all the components
goto replace

:replace
cls
echo # Rename - by CorpNewt #
echo.
echo Current Path: !path!
echo Replacing: !lookExt! with !repExt!
echo.
set /a repCount = 0
set /a totalCount = 0
REM Get the length to check
call :strlen len lookExt
set /a revLen=!len!*-1

pushd "!path!"
for /r %%f in (*.*) do (
	set /a totalCount += 1
	set currentFile = %%f
	call :substring ext "%%f" !revLen!
	if /i "!ext!" == "!lookExt!" (
		REM We got one!
		set /a repCount += 1
		call :namefrompath "%%f" newName
		call :substring fileName "!newName!" "0,!revLen!"
		REM Rename the file
		ren "%%f" "!fileName!!repExt!"
		echo .... Renamed "%%f" to "!fileName!!repExt!"
	)
)
popd
echo.
echo Done.
echo.
echo Press [enter] to go to summary...
pause > nul
goto end

:end
cls
echo # Rename - by CorpNewt #
echo.
set "repFile=files"
set "totFile=files"
if "!repCount!" == "1" (
	set "repFile=file"
)
if "!totalCount!" == "1" (
	set "totFile=file"
)
echo !totalCount! !totFile! checked.
echo !repCount! !repFile! renamed.
echo.
echo Press [enter] to exit...
echo.
pause > nul
exit /b

:namefrompath <path> <result>
set "%~2=%~nx1"
goto :EOF

:strlen <resultVar> <stringVar>
set "s=!%~2!#"
set "len=0"
for %%P in (4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (
    if "!s:~%%P,1!" NEQ "" ( 
        set /a "len+=%%P"
        set "s=!s:~%%P!"
    )
)
set "%~1=%len%"
exit /b

:substring <result> <source> <remove>
set test=%~2
set %~1=!test:~%~3!
goto :EOF

:getExtension <path> <return>
set "%~2=%~x1"
goto :EOF