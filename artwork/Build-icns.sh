#!/bin/bash

origimg=bibunsho7_icon.png

rm -rf bibunsho7.iconset
mkdir -p bibunsho7.iconset
sips -z 1024 1024 ${origimg}  --out bibunsho7.iconset/icon_512x512@2x.png
sips -z 512 512   ${origimg}  --out bibunsho7.iconset/icon_512x512.png
sips -z 512 512   ${origimg}  --out bibunsho7.iconset/icon_256x256@2x.png
sips -z 256 256   ${origimg}  --out bibunsho7.iconset/icon_256x256.png
sips -z 256 256   ${origimg}  --out bibunsho7.iconset/icon_128x128@2x.png
sips -z 128 128   ${origimg}  --out bibunsho7.iconset/icon_128x128.png
sips -z 64 64   ${origimg}  --out bibunsho7.iconset/icon_32x32@2x.png
sips -z 32 32   ${origimg}  --out bibunsho7.iconset/icon_32x32.png
sips -z 32 32   ${origimg}  --out bibunsho7.iconset/icon_16x16@2x.png
sips -z 16 16   ${origimg}  --out bibunsho7.iconset/icon_16x16.png

# for png in bibunsho7.iconset/*.png; do
#     mv ${png} bibunsho7.iconset/$(basename ${png} .png)
# done

iconutil -c icns bibunsho7.iconset
rm -rf bibunsho7.iconset

exit

# This is free and unencumbered software released into the public domain.
#  
# Anyone is free to copy, modify, publish, use, compile, sell, or distribute this 
# software, either in source code form or as a compiled binary, for any purpose, 
# commercial or non-commercial, and by any means.
#  
# In jurisdictions that recognize copyright laws, the author or authors of this 
# software dedicate any and all copyright interest in the software to the public 
# domain. We make this dedication for the benefit of the public at large and to 
# the detriment of our heirs and successors. We intend this dedication to be an 
# overt act of relinquishment in perpetuity of all present and future rights to 
# this software under copyright law.
#  
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
# AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN 
# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION 
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#  
# For more information, please refer to http://unlicense.org
