{ stdenv, fetchurl, libX11, libXext, gettext, libICE, libXtst, libXi, libSM, xorgserver
, autoconf, automake, cvs, libtool, nasm, utilmacros, pixman, xkbcomp, xkeyboard_config
, fontDirectories, fontutil, libgcrypt, gnutls, pam }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "tigervnc-1.1.0";
  
  src = fetchurl {
    url = "mirror://sourceforge/tigervnc/${name}.tar.gz";
    sha256 = "1x30s12fwv9rk0fnwwn631qq0d8rpjjx53bvzlx8c91cba170jsr";
  };

  configureFlags = "--enable-nls";

  inherit fontDirectories;

  patchPhase = ''
    sed -i -e 's,$(includedir)/pixman-1,${pixman}/include/pixman-1,' unix/xserver/hw/vnc/Makefile.am
    sed -i -e '/^$pidFile/a$ENV{XKB_BINDIR}="${xkbcomp}/bin";' unix/vncserver 
    sed -i -e '/^\$cmd \.= " -pn";/a$cmd .= " -xkbdir ${xkeyboard_config}/etc/X11/xkb";' unix/vncserver 

    fontPath=
    for i in $fontDirectories; do
      for j in $(find $i -name fonts.dir); do
        addToSearchPathWithCustomDelimiter "," fontPath $(dirname $j)
      done
    done
    
    sed -i -e '/^\$cmd \.= " -pn";/a$cmd .= " -fp '"$fontPath"'";' unix/vncserver 
  '';

  # I don't know why I can't use in the script
  # this:  ${concatStringsSep " " (map (f: "${f}") xorgserver.patches)}
  xorgPatches = xorgserver.patches;

  postBuild = ''
    # Build Xvnc
    tar xf ${xorgserver.src}
    cp -R xorg*/* unix/xserver
    pushd unix/xserver
    for a in $xorgPatches
    do
      patch -p1 < $a
    done
    patch -p1 < ../xserver18.patch
    autoreconf -vfi
    ./configure $configureFlags --disable-xinerama --disable-xvfb --disable-xnest --disable-xorg --disable-dmx --disable-dri --disable-dri2 --disable-glx
    make TIGERVNC_SRCDIR=`pwd`/../..
    popd
  '';

  # I don't know why I need this; it may have to do with this problem:
  # http://bugs.gentoo.org/show_bug.cgi?id=142852
  preInstall = ''
    sed -i -e s,@MKINSTALLDIRS@,`pwd`/mkinstalldirs, po/Makefile
  '';

  postInstall = ''
    pushd unix/xserver
    make TIGERVNC_SRCDIR=`pwd`/../.. install
  '';

  buildInputs =
    [ libX11 libXext gettext libICE libXtst libXi libSM autoconf automake cvs
      libtool nasm utilmacros fontutil libgcrypt gnutls pam
    ] ++ xorgserver.buildNativeInputs;

  propagatedBuildNativeInputs = xorgserver.propagatedBuildNativeInputs;

  meta = {
    homepage = http://www.tigervnc.org/;
    license = "GPLv2+";
    description = "Fork of tightVNC, made in cooperation with VirtualGL";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };

}
