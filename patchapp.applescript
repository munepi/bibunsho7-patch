#!/usr/bin/osacompile -o Patch.app

set n to 150 -- 139 lines
set progress total steps to n
set progress description to "Patch.app: 実行中..."
set progress additional description to "待機中..."

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

        set progress completed steps to i

        -- 
        if progrMsg = "+ exit" then
            exit repeat
        else if progrMsg = "+ exit 1" then
            error number -128
        end if
    end repeat
    -- quit
    set progress completed steps to n
    set progress additional description to "完了"
    activate
    display alert "完了"
    return

on error
    set progrMsg to do shell script "tail -n 2" & space & patchLog
    set progress additional description to progrMsg

    activate
    display alert "失敗：ログファイル" & space & patchLog & space & "をご確認ください。"
end try
