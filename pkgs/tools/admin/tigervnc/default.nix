{stdenv, fetchsvn, libX11, libXext, gettext, libICE, libXtst, libXi, libSM, xorgserver,
autoconf, automake, cvs, libtool, nasm, utilmacros, pixman }:

with stdenv.lib;

stdenv.mkDerivation {
  name = "tigervnc-svn-4086";
  src = fetchsvn {
    url = https://tigervnc.svn.sourceforge.net/svnroot/tigervnc/trunk;
    rev = 4086;
    sha256 = "0aqn9d5yz21k5l4mwh5f73il77w2rbvsrz91z3lz4bizivvkwszc";
  };

  preConfigure = ''
    autoreconf -vfi
  '';

  configureFlags = "--enable-nls";

  patchPhase = ''
    sed -i -e 's,$(includedir)/pixman-1,${pixman}/include/pixman-1,' unix/xserver/hw/vnc/Makefile.am
  '';

  xorgPatches = xorgserver.patches;

  postBuild = ''
    # Build Xvnc
    tar xf ${xorgserver.src}
    cp -R xorg*/* unix/xserver
    pushd unix/xserver
    # This below does not work and I don't know why:
    #for a in ${concatStringsSep " " (map (f: "${f}") xorgserver.patches)}
    for a in $xorgPatches
    do
      patch -p1 < $a
    done
    patch -p1 < ../xserver17.patch
    autoreconf -vfi
    ./configure --prefix=$out --disable-xinerama --disable-xvfb --disable-xnest --disable-xorg --disable-dmx
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
    libtool nasm utilmacros ] ++ xorgserver.buildNativeInputs;

  propagatedBuildInputs = xorgserver.propagatedBuildNativeInputs;

  meta = {
    homepage = http://www.tigervnc.org/;
    license = "GPLv2+";
    description = "Fork of tightVNC, made in cooperation with VirtualGL";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };

}
