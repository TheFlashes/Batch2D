@ECHO off
SETLOCAL ENABLEDELAYEDEXPANSION

REM START New line character, thanks to https://stackoverflow.com/a/269819
set NLM=^


set NL=^^^%NLM%%NLM%^%NLM%%NLM%
REM END New line character

:GAME_INIT
    SET "map_width=50"
    SET "map_heigth=50"
    SET "map_blankChar=."

    SET "render_width=10"
    SET "render_heigth=10"

    REM Map "array"
    FOR /L %%y in (1, 1, !map_heigth!) DO (
        FOR /L %%x in (1, 1, !map_width!) DO (
            SET "x%%xy%%y=!map_blankChar!"
        )
    )
	
	SET "border_tl=É"
	SET "border_tb=Í"
	SET "border_tr=»"
	SET "border_side=º"
	SET "border_bl=È"
	SET "border_br=¼"

:RENDER
	REM TOP BORDER RENDER
    SET "buffer=%border_tl%"
    FOR /L %%x in (1, 1, !render_width!) DO (
        SET "buffer=!buffer!%border_tb%"
    )
	SET "buffer=!buffer!%border_tr%!NL!"
	
	REM MAP RENDER
    FOR /L %%y in (1, 1, !render_heigth!) DO (
		SET "buffer=!buffer!%border_side%"
        FOR /L %%x in (1, 1, !render_width!) DO (
            SET "buffer=!buffer!!x%%xy%%y!"
        )
        SET "buffer=!buffer!%border_side%!NL!"
    )
	
	REM BOTTOM BORDER RENDER
	SET "buffer=!buffer!%border_bl%"
    FOR /L %%x in (1, 1, !render_width!) DO (
        SET "buffer=!buffer!%border_tb%"
    )
	SET "buffer=!buffer!%border_br%!NL!"
	
    ECHO %buffer%



