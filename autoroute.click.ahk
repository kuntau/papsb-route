#c::
InputBox, routenum, Route Number, Enter route number
routedir = %a_scriptdir%\
routefile = %routenum%.route
fullpath = %routedir%%routefile%
loop {
    if ErrorLevel
        break
    FileReadLine, needle, %fullpath%, %a_index%
    msgbox, needle is %needle%
    needle = %needle%
    FindCoordinate(needle)
}
return
#z::
MoveStage(3)
return
#x::
InputBox, routenum, Route Number, Enter route number
routedir = %a_scriptdir%\
routefile = %routenum%.route
fullpath = %routedir%%routefile%
GPSManager()
ClickStageList()
loop {
    if ErrorLevel
        break
    FileReadLine, needle, %fullpath%, %a_index%
    msgbox, index is %a_index%
    needle = %needle%
    FindCoordinate(needle)
    MoveStage(a_index)
}
return
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

GPSManager() {
    WinWait, GPS Manager-
    IfWinNotActive, GPS Manager-, WinActivate, GPS Manager-
    WinWaitActive, GPS Manager-
}
ClickStageList() {
    MouseClick, left,  222,  196 ;click first item on stagelist
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
    Loop {
        if ErrorLevel
            break
        FileReadLine, curtext, %coordfile%, %a_index% 
        StringSplit, result, curtext, `,
        ;msgbox, %result1%
        if busstop = %result1%
        {
            WriteCoordinate(result2, result3)
            break 
        }
        else continue
    }
    return false
}

SplitCoordinate(coord) {
    stringsplit, explode, coord, .
    msgbox, first part %explode1%, 2nd %explode2%, 3rd %explode3%
}

WriteCoordinate(latitude, longitude) {
    MouseClick, left,  120,  685 ;click latitude firstbox
    Sleep, 100
    stringsplit, explode, latitude, .
    Send, %explode1%{TAB}%explode2%{TAB}%explode3%{TAB}n{TAB}{TAB}
    Sleep, 100
    stringsplit, explode, longitude, .
    Send, %explode1%{TAB}%explode2%{TAB}%explode3%{TAB}e
    Sleep, 100
    Send,{ALTDOWN}a{ALTUP}

    return
}
