{stdenv, fetchsvn, libX11, libXext, gettext, libICE, libXtst, libXi, libSM, xorgserver,
autoconf, automake, cvs, libtool, nasm, utilmacros, pixman, xkbcomp, xkeyboard_config,
fontDirectories, fontutil }:

with stdenv.lib;

stdenv.mkDerivation {
  name = "tigervnc-svn-4232";
  src = fetchsvn {
    url = https://tigervnc.svn.sourceforge.net/svnroot/tigervnc/trunk;
    rev = 4232;
    sha256 = "070lsddgx6qj7bpw4p65w54fr7z46vp8wyshv9p0fh3k5izrfnxj";
  };

  preConfigure = ''
    autoreconf -vfi
  '';

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
    ./configure --prefix=$out --disable-xinerama --disable-xvfb --disable-xnest --disable-xorg --disable-dmx --disable-dri --disable-dri2 --disable-glx
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

  buildInputs = [ libX11 libXext gettext libICE libXtst libXi libSM autoconf automake cvs
    libtool nasm utilmacros fontutil ] ++ xorgserver.buildNativeInputs;

  propagatedBuildInputs = xorgserver.propagatedBuildNativeInputs;

  meta = {
    homepage = http://www.tigervnc.org/;
    license = "GPLv2+";
    description = "Fork of tightVNC, made in cooperation with VirtualGL";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };

}
