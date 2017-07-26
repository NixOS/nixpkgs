#!/bin/sh

set -e

GARGDIST=build/macosx.release
BUNDLE=${out}/Applications/Gargoyle.app/Contents
TERPS="
advsys/advsys
agility/agility
alan2/alan2
alan3/alan3
bocfel/bocfel
frotz/frotz
garglk/gargoyle
geas/geas
git/git
glulxe/glulxe
hugo/hugo
jacl/jacl
level9/level9
magnetic/magnetic
nitfol/nitfol
scare/scare
scott/scott
tads/tadsr
"

mkdir -p $BUNDLE/MacOS
mkdir -p $BUNDLE/Frameworks
mkdir -p $BUNDLE/Resources
mkdir -p $BUNDLE/PlugIns

install_name_tool -id @executable_path/../Frameworks/libgarglk.dylib $GARGDIST/garglk/libgarglk.dylib
for file in $TERPS
do
install_name_tool -change @executable_path/libgarglk.dylib @executable_path/../Frameworks/libgarglk.dylib $GARGDIST/$file || true
cp -f $GARGDIST/$file $BUNDLE/PlugIns
done

cp -f garglk/launcher.plist $BUNDLE/Info.plist
cp -f $GARGDIST/garglk/gargoyle $BUNDLE/MacOS/Gargoyle
cp -f $GARGDIST/garglk/libgarglk.dylib $BUNDLE/Frameworks
cp -f $GARGDIST/garglk/libgarglk.dylib $BUNDLE/PlugIns
cp -f garglk/launchmac.nib $BUNDLE/Resources/MainMenu.nib
cp -f garglk/garglk.ini $BUNDLE/Resources
cp -f garglk/*.icns $BUNDLE/Resources
cp -f licenses/* $BUNDLE/Resources

mkdir $BUNDLE/Resources/Fonts
cp fonts/LiberationMono*.ttf $BUNDLE/Resources/Fonts
cp fonts/LinLibertine*.otf $BUNDLE/Resources/Fonts

mkdir -p ${out}/bin
ln -s $BUNDLE/MacOS/Gargoyle ${out}/bin/gargoyle
