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
