#/::
msgbox, win+z: WayCon Create Stage\nwin+x: GPS Manager Insert Coordinate
return
#z::
InputBox, routenum, WayCon Auto Routes, Enter route number
routedir = %a_scriptdir%\
routefile = %routenum%.route
fullpath = %routedir%%routefile%
ActivateWaycon()
;Send, 1000
loop, Read, %fullpath% 
{
    Send, {alt down}n{alt up}
    Send, %a_loopreadline%
    Send, {alt down}u{alt up}
    Send, %a_index%
    Send, {alt down}a{alt up}
    ;msgbox, index is %a_index% and needle is %needle%
    Sleep, 100
    ;needle = %needle%
    ;FindCoordinate(needle)
    ;Send, {TAB 8}{DOWN}
}
return

#x::
InputBox, routenum, GPS Manager Auto, Enter route number
routedir = %a_scriptdir%\
routefile = %routenum%.route
fullpath = %routedir%%routefile%
GPSManager()
ClickStageList()
;Sleep, 1000
loop, read, %fullpath%
{
;    if ErrorLevel
;        break
;    FileReadLine, needle, %fullpath%, %a_index%
    ;msgbox, index is %a_index% and needle is %needle%
;    needle = %needle% ;this assignment will trim extra whitespace
    needle = %a_loopreadline%
    FindCoordinate(needle)
    Send, {TAB 9}{DOWN} ;move to the next item
    ;MoveStage(a_index)
}
Send, {tab 8}
return

ActivateWaycon() {
    SetTitleMatchMode, 1
    WinWait, Stages for Service
}
GPSManager() {
    WinWait, GPS Manager-
    ;IfWinNotActive, GPS Manager-, WinActivate, GPS Manager-
    ;WinWaitActive, GPS Manager-
}
ClickStageList() {
    ;MouseClick, left,  222,  196 ;click first item on stagelist
    Send, {tab 3}{down}
}
MoveStage(count) {
    MouseClick, left,  222,  196 ;click first item on stagelist
    Sleep, 100
    Send, {HOME}
    Sleep, 100
    ;msgbox, we are going down %count%
    Loop, %count%
    {
        Send, {DOWN}
        Sleep, 300
    }
}
FindCoordinate(busstop) {
    coordfile = %a_scriptdir%\coordinate.csv
    Loop, read, %coordfile%
    {
;        if ErrorLevel
;            break
        /*
         * split the result in token separated by comma ','. escaped with `
         */
        StringSplit, result, a_loopreadline, `,
        ;msgbox, %result1%
        /*
         * %result1% is the bus stop
         * %result2% is the latitude
         * %result3% is the longitude
         * %result4% is the description *not in use in script*
         */
        if busstop = %result1%
        {
            Sleep, 200
            WriteCoordinate(result2, result3)
            break 
        }
        ;simple hack to overcome error by problematic bus stop.
        else if (busstop = "9C1-8" or busstop = "9C1-9" or busstop = "P14-7" or busstop = "P14-8" or busstop = "9C-3" or busstop = "9C-4") {
            msgbox, No coordinate found for bus stop %busstop%!
            Send, {TAB 9}
            break
        }
        else if result1 = "END"
            msgbox, End of file no coordinate found for bus stop %busstop%!
        else continue
    }
    return false
}
SplitCoordinate(coord) {
    stringsplit, explode, coord, .
    msgbox, first part %explode1%, 2nd %explode2%, 3rd %explode3%
}

WriteCoordinate(latitude, longitude) {
    ;MouseClick, left,  120,  685 ;click latitude firstbox
    Send, {TAB 3}
    Sleep, 50
    stringsplit, explode, latitude, .
    Send, %explode1%{TAB}%explode2%{TAB}%explode3%{TAB}n{TAB}{TAB}
    Sleep, 50
    stringsplit, explode, longitude, .
    Send, %explode1%{TAB}%explode2%{TAB}%explode3%{TAB}e
    Sleep, 50
    Send,{ALTDOWN}a{ALTUP}

    return
}

    /* REFERENCE DATA
    #v::
    WinWait, GPS Manager-[NputraGPS (No Filter)], GPS Locations Scanni
    IfWinNotActive, GPS Manager-[NputraGPS (No Filter)], GPS Locations Scanni, WinActivate, GPS Manager-[NputraGPS (No Filter)], GPS Locations Scanni
    WinWaitActive, GPS Manager-[NputraGPS (No Filter)], GPS Locations Scanni
    MouseClick, left,  222,  196 ;click first item on stagelist
    Sleep, 100
    MouseClick, left,  120,  685 ;click latitude firstbox
    Sleep, 100
    Send, 1{TAB}{TAB}{TAB}n{TAB}{TAB}1{TAB}{TAB}{TAB}e{ALTDOWN}a{ALTUP}
    Sleep, 100
    MouseClick, left,  222,  198
    Sleep, 100
    Send, {DOWN} ;move to next item in stage list 
    return

    ^!n::
    IfWinExist Untitled - Notepad
    WinActivate
    else
    Run Notepad
    return
    */
