@ECHO off
SETLOCAL ENABLEDELAYEDEXPANSION

REM START New line character, thanks to https://stackoverflow.com/a/269819
set NLM=^


set NL=^^^%NLM%%NLM%^%NLM%%NLM%
REM END New line character

:GAME_INIT
	if "%~1"=="" (GOTO :GAME_INIT_END)
    SET "map_width=50"
    SET "map_heigth=50"
    SET "map_blankChar=."

    SET "render_width=21"
    SET "render_heigth=10"

	CALL Hero.bat

    REM Map "array"
    FOR /L %%y in (1, 1, !map_heigth!) DO (
        FOR /L %%x in (1, 1, !map_width!) DO (
            SET "x%%xy%%y=!map_blankChar!"
        )
    )

	SET "x5y3=@"
	
	SET "border_tl=É"
	SET "border_tb=Í"
	SET "border_tr=»"
	SET "border_side=º"
	SET "border_bl=È"
	SET "border_br=¼"
	GOTO :EOF
:GAME_INIT_END

:RENDER
	if "%~1"=="" (GOTO :RENDER_END)

	SET /a "render_w_half=%render_width%/2"
	SET /a "render_h_half=%render_heigth%/2"

	SET /a "render_x_start=%hero_x%-%render_w_half%"
	SET /a "render_x_end=%hero_x%+%render_w_half%"

	SET /a "render_y_start=%hero_y%-%render_h_half%"
	SET /a "render_y_end=%hero_y%+%render_h_half%"

	CLS

	REM TOP BORDER RENDER
    SET "buffer=%border_tl%"
    FOR /L %%x in (1, 1, !render_width!) DO (
        SET "buffer=!buffer!%border_tb%"
    )
	SET "buffer=!buffer!%border_tr%!NL!"
	
	REM MAP RENDER
	SET bufferY=-1
    FOR /L %%y in (!render_y_start!, 1, !render_y_end!) DO (
		SET /A bufferY=!bufferY!+1
		SET "buffer=!buffer!%border_side%"

		SET bufferX=-1
        FOR /L %%x in (!render_x_start!, 1, !render_x_end!) DO (
			SET /A bufferX=!bufferX!+1
			SET tmp_x=%%x
			SET tmp_y=%%y
			SET "offTheMap=false"
			FOR %%i in (!tmp_x! !tmp_y!) DO IF %%i LEQ 0 SET "offTheMap=true"
			IF !tmp_x! GEQ %map_width% SET "offTheMap=true"
			IF !tmp_y! GEQ %map_heigth% SET "offTheMap=true"

			IF "!bufferX!!bufferY!"=="%render_w_half%%render_h_half%" (
				SET "buffer=!buffer!%hero_char%"
			) ELSE (
				IF "!offTheMap!"=="true" (
					SET "buffer=!buffer! "
				) ELSE (
					SET "buffer=!buffer!!x%%xy%%y!"
				)
			)
        )
        SET "buffer=!buffer!%border_side%!NL!"
    )
	
	REM BOTTOM BORDER RENDER
	SET "buffer=!buffer!%border_bl%"
    FOR /L %%x in (1, 1, !render_width!) DO (
        SET "buffer=!buffer!%border_tb%"
    )
	SET "buffer=!buffer!%border_br%"
	
    ECHO %buffer%
	ECHO x: %hero_x% ^| y: %hero_y%
	GOTO :EOF
:RENDER_END

:CONTROLS
	if "%~1"=="" (GOTO :CONTROLS_END)
	SET /P "move=W A S D > "

	if "%move%"=="w" SET /A hero_y=%hero_y%-1
	if "%move%"=="s" SET /A hero_y=%hero_y%+1
	if "%move%"=="a" SET /A hero_x=%hero_x%-1
	if "%move%"=="d" SET /A hero_x=%hero_x%+1
	if "%move%"=="q" exit /b

	GOTO :EOF
:CONTROLS_END

CALL :GAME_INIT 1
:GAME
	CALL :RENDER 1
	CALL :CONTROLS 1
	GOTO :GAME

:END



