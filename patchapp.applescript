#!/usr/bin/osacompile -o Patch.app

# This program is licensed under the terms of the MIT License.
#
# Copyright 2017-2022 Munehiro Yamamoto <munepixyz@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

-- 700 lines /tmp/bibunsho7-patch.log => 3.5min
set progressTimeout to 5 -- minutes
set progressMaxN to (progressTimeout * 60 * 10)
set progress total steps to progressMaxN
set progress description to "Patch.app: 実行中..."
set progress additional description to "待機中..."

set patchLog to "/tmp/bibunsho7-patch.log"

try
    -- execute shell script on background
    do shell script quoted form of (POSIX path of (path to resource "Patch.sh")) & ¬
        space & "&>" & patchLog & space & "&" with administrator privileges

    -- activate the progress bar intentionally
    activate

    repeat with i from 1 to progressMaxN
        delay 0.1
        -- update progress description and completed steps
        set progrMsg to do shell script "tail -n 1" & space & patchLog & space & "| fold"
        set progress additional description to progrMsg
        set i to do shell script "wc -l" & space & patchLog & space & "| sed \"s, *,,\" | cut -f1 -d \" \""

        set progress completed steps to (i * progressTimeout)

        if progrMsg = "cjk-gs-integrate [DEBUG]: overwriting with the new one ..."
            set progress description to "Patch.app: 実行中... (この処理にしばらく時間がかかる場合があります)"
        else
            set progress description to "Patch.app: 実行中..."
        end if

        --
        if progrMsg = "+ exit 0" then
            exit repeat
        else if progrMsg = "+ exit 1" then
            error number -128
        end if
    end repeat
    -- some exception handling
    if progrMsg = "+ exit 0" then
    else if progrMsg = "cp: /Volumes/Bibunsho7-patch/ptex-fontmaps/maps/hiragino*: No such file or directory"
        error number -2
    else
        error number -128
    end if

    -- quit
    set progress completed steps to progressMaxN
    set progress additional description to "完了"
    activate
    display alert "完了"
    return

on error message number errn
    set progress additional description to progrMsg
    activate

    set plzChkLog to "失敗：ログファイル" & space & patchLog & space & "をご確認ください。"

    if errn = -2 then
        display alert plzChkLog & "複数個の Bibunsho7-patch-<バージョン>.dmg を開いています。"
    else
        set progrMsg to do shell script "tail -n 2" & space & patchLog & space & "| fold"
        set progress additional description to progrMsg
        display alert plzChkLog
    end if
end try
