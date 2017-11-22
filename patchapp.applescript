#!/usr/bin/osacompile -o Patch.app

set n to 150 -- 132 lines
set progress total steps to n
set progress description to "Patch.app: 実行中..."
set progress additional description to "Preparing to process"

set patchLog to "/tmp/bibunsho7-patch.log"

try
    -- execute shell script on background
    do shell script quoted form of (POSIX path of (path to resource "Patch.sh")) & ¬
        space & "&>" & patchLog & space & "&" with administrator privileges

    repeat with i from 1 to n
        delay 0.1

        -- update progress description and completed steps 
        set progrMsg to do shell script "tail -n 1" & space & patchLog
        set progress additional description to progrMsg
        set i to do shell script "wc -l" & space & patchLog & space & "| sed \"s, *,,\" | cut -f1 -d \" \""

        --
        if progrMsg = "+ exit" then
            set i to n
        else if progrMsg = "+ exit 1" then
            error number -128
        end if
        
        set progress completed steps to i
    end repeat
    quit
    return
on error
    activate
    display alert "失敗"
    return
end try

on quit
    activate
    display dialog "完了"
    continue quit -- allows the script to quit
end quit
