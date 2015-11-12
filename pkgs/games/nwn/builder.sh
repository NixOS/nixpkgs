source $stdenv/setup

# Several variables
export CC32="$CC -m32"
export CC64="$CC"
export CC="$CC32"

# Extract gog setup
ln -s $gogSetup setup.exe
ln -s $gogData1 setup-1.bin
ln -s $gogData2 setup-2.bin
innoextract -e -m setup.exe

# Extract Game Icons
mkdir icons
icotool -x -p 0 app/gfw_high.ico -o icons

# Extract Kingmaker Files
unzip $gogmods
7z x KingmakerSetup.exe -xr0\!*PLUGINSDIR* -xr\!*.exe -xr\!*.dat -okingmakertmp

# Create destination directory
mkdir -p $out/nwn

# Compile nw*
nwcompile() {
  cp -r ${!1} $1
  chmod -R +w $1
  patchShebangs $1
  pushd $1
  eval "$2"
  sed -i \
    -e "s|^\$machine = .*|\$machine = \"$system\";|" \
    -e "s|-I/|-I/does-not-exist/|g" \
    -e "s|-L/|-L/does-not-exist/|g" \
    ./$1_install.pl
  find -name \*.so -delete
  ./$1_install.pl build
  find -name \*.so -exec strip -s {} \;
  install -m755 $1/$1.so $out/nwn/$1.so
  popd
}

nwcompile nwmovies "
  sed -i \
    -e 's|^\$mplayer = .*|\$mplayer = \"\";|' \
    -e 's|^\$plaympeg = .*|\$plaympeg = \"\";|' \
    -e 's|^\$binkplayer = .*|\$binkplayer = \"$binkplayer/bin/BinkPlayer\";|' \
    nwmovies/nwmovies.pl
"
nwcompile nwuser
nwcompile nwmouse "sed -i 's|linux/user.h|sys/user.h|' nwmouse/nwmouse_cookie.c"
nwcompile nwlogger "sed -i 's|linux/user.h|sys/user.h|' nwlogger/nwlogger_cookie.c"

# Move game files to directory
cp -r app/* $out/nwn

# Extract Game Clients
tar -zxvf $clientgold -C $out/nwn
tar -zxvf $clienthotu -C $out/nwn

# Install Kingmaker Files
cp -r kingmakertmp/\$0/* $out/nwn

# Extract Latest Patch
tar -zxvf $clientpatch -C $out/nwn

# Check the Installation
pushd $out/nwn
patchShebangs fixinstall
./fixinstall
popd

# Remove Unneeded Files & Directories
rm -r \
  $out/nwn/SDL-* \
  $out/nwn/*.dll \
  $out/nwn/*.exe \
  $out/nwn/ereg \
  $out/nwn/utils \
  $out/nwn/lib \
  $out/nwn/premium/*.exe \
  $out/nwn/miles/*.dll \
  $out/nwn/fixinstall \
  $out/nwn/nwn \
  $out/nwn/dmclient

# Install nwmovies Perl script
install -D -m755 nwmovies/nwmovies.pl $out/nwn/nwmovies.pl

# Install binkplayer binaries
install -D -m755 nwmovies/nwmovies/binklib.so $out/nwn/nwmovies/binklib.so

# Install libdis binaries for nwmovies
install -D -m755 nwmovies/nwmovies/libdis/libdisasm.so $out/nwn/nwmovies/libdis/libdisasm.so

# Install 64bit binaries if Arch64
if [ "$system" = "x86_64-linux" ]; then
  install -D -m755 nwuser/nwuser/nwuser64.so $out/nwn/nwuser64.so
fi

# Install libdis binaries for nwmouse
install -D -m755 nwmouse/nwmouse/libdis/libdisasm.so $out/nwn/nwmouse/libdis/libdisasm.so

# Install libdis binaries for nwlogger
install -D -m755 nwlogger/nwlogger/libdis/libdisasm.so $out/nwn/nwlogger/libdis/libdisasm.so

# Copy the original license file
cp app/nwncdkey.ini $out/nwn/nwncdkey.ini

# Install Cursors
mkdir -p $out/nwn/nwmouse/cursors/
tar -zxvf nwmouse/nwmouse/cursors.tar.gz -C $out/nwn/nwmouse/cursors/

# Patch ELFs
if [ "$system" = "x86_64-linux" ]; then
  LD=$(cat $NIX_CC/nix-support/dynamic-linker-m32)
else
  LD=$(cat $NIX_CC/nix-support/dynamic-linker)
fi

find $out/nwn -name \*.so -exec patchelf \
  --set-rpath "$deps" \
  {} \;

for i in $out/nwn/{nwmain,nwserver}; do
  patchelf \
    --set-interpreter "$LD" \
    --set-rpath "$deps" \
    "$i"
done

# Install Launcher (Client)
mkdir -p $out/bin

sed \
  -e "s|@out@|$out|g" \
  -e "s|@shell@|$SHELL|" \
  $launcher > $out/bin/nwn
chmod +x $out/bin/nwn

cat >$out/bin/nwserver <<EOF
#!$SHELL
cd $out/nwn
exec ./nwserver \"\$@\"
EOF
chmod +x $out/bin/nwserver

# Install Desktop File
mkdir -p $out/share/applications
cat >$out/share/applications/nwn.desktop <<EOF
[Desktop Entry]
Encoding=UTF-8
Name=Neverwinter Nights Diamond
GenericName=Neverwinter Nights
Comment=Play Neverwinter Nights Diamond
Exec=$out/bin/nwn
Icon=nwn
StartupNotify=true
Terminal=false
Type=Application
Categories=Qt;KDE;GNOME;Application;Game;
EOF

# Install Icon Files
install -D -m644 icons/gfw_high_6_256x256x32.png $out/share/icons/hicolor/256x256/apps/nwn.png
install -D -m644 icons/gfw_high_7_48x48x32.png $out/share/icons/hicolor/48x48/apps/nwn.png
install -D -m644 icons/gfw_high_8_32x32x32.png $out/share/icons/hicolor/32x32/apps/nwn.png
install -D -m644 icons/gfw_high_9_16x16x32.png $out/share/icons/hicolor/16x16/apps/nwn.png
