{
stdenv, fetchurl, xorg, patchelf, unzip, fontconfig, freetype, glibc
}:

with stdenv.lib;

let
  version = "15.12";
in

# /usr/lib/dri/fglrx_dri.so must point to /run/opengl-driver/lib/fglrx_dri.so

stdenv.mkDerivation {

  name = "amd-non-free-${version}-libs";

  src = fetchurl {
    url = "http://www2.ati.com/drivers/linux/radeon-crimson-${version}-15.302-151217a-297685e.zip";
    curlOpts = "--referer http://support.amd.com/en-us/download/desktop?os=Linux%20x86_64";
    sha256 = "704f2dfc14681f76dae3b4120c87b1ded33cf43d5a1d800b6de5ca292bb61e58";
  };

  inherit glibc /* glibc only used for setting interpreter */;
  dontStrip = true;
  dontPatchELF = true;
  preferLocalBuild = true;
  enableParallelBuilding = true;
  gcc = stdenv.cc.cc;
  arch =
    if stdenv.system == "i686-linux" then
      "x86"
    else if stdenv.system == "x86_64-linux" then
      "x86_64"
    else throw "amd-non-free is Linux only. Sorry. The build was stopped.";
  lib_arch =
    if stdenv.system == "i686-linux" then
      "lib"
    else if stdenv.system == "x86_64-linux" then
      "lib64"
    else false;
  DIR_DEPENDING_ON_XORG_VERSION =
    if stdenv.system == "i686-linux" then
      "xpic"
    else if stdenv.system == "x86_64-linux" then
      "xpic_64a"
    else false;

  buildInputs = [
    xorg.libXrender xorg.libXext xorg.libX11 xorg.libXinerama xorg.libSM xorg.libXrandr xorg.libXxf86vm
    xorg.xf86vidmodeproto xorg.imake xorg.libICE patchelf unzip fontconfig freetype
  ];

  LD_LIBRARY_PATH = stdenv.lib.concatStringsSep ":" [
    "${xorg.libXrandr}/lib/"
    "${xorg.libXrender}/lib/"
    "${xorg.libXext}/lib/"
    "${xorg.libX11}/lib/"
    "${xorg.libXinerama}/lib/"
    "${xorg.libSM}/lib/"
    "${xorg.libICE}/lib/"
    "${stdenv.cc.cc}/lib/"
  ];

  # This adds the following libraries as symlinks in $out/lib so that they
  # appear in /run/opengl-driver/lib which is added to the LD_LIBRARY_PATH.
  extraDRIlibs = [ xorg.libXrandr xorg.libXrender xorg.libXext xorg.libX11 xorg.libXinerama xorg.libSM xorg.libICE ];

  phases = [ "unpackPhase" "patchPhase" "buildPhase" "fixupPhase" ];
 
  preUnpack = "die(){ echo $@; exit 1; }";
  postUnpack = "sh fglrx*/amd-driver-installer-* --extract .";
  prePatch = ''cd ..'';

  buildPhase = ''
    mkdir -p $out/lib/xorg
    for d1 in \
      $TMP/arch/$arch/usr/X11R6/$lib_arch/modules/dri \
      $TMP/arch/$arch/usr/X11R6/$lib_arch/modules/dri/* \
      $TMP/arch/$arch/usr/X11R6/$lib_arch/*.so* \
      $TMP/arch/$arch/usr/$lib_arch/*
    do
      cp -r $d1 $out/lib
    done
    cp -r $TMP/$DIR_DEPENDING_ON_XORG_VERSION/usr/X11R6/$lib_arch/modules $out/lib/xorg
    cp -r $TMP/arch/$arch/usr/X11R6/$lib_arch/fglrx/fglrx-libGL.so.1.2 $out/lib/fglrx-libGL.so.1.2
    ln -s libatiuki.so.1.0 $out/lib/libatiuki.so.1
    ln -s fglrx-libGL.so.1.2 $out/lib/libGL.so.1
    ln -s fglrx-libGL.so.1.2 $out/lib/libGL.so
    # make xorg use the ati version
    ln -s $out/lib/xorg/modules/extensions/{fglrx/fglrx-libglx.so,libglx.so}
    # Correct some paths that are hardcoded into binary libs.
    if [ "$arch" ==  "x86_64" ]; then
      for lib2 in \
        xorg/modules/extensions/fglrx/fglrx-libglx.so \
        xorg/modules/glesx.so \
        dri/fglrx_dri.so \
        fglrx_dri.so \
        fglrx-libGL.so.1.2
      do
        oldPaths="/usr/X11R6/lib/modules/dri"
        newPaths="/run/opengl-driver/lib/dri"
        sed -i -e "s|$oldPaths|$newPaths|" $out/lib/$lib2
      done
      for pelib1 in \
        fglrx_dri.so \
        dri/fglrx_dri.so
      do
        patchelf --remove-needed libX11.so.6 $out/lib/$pelib1
      done

    else

      oldPaths="/usr/X11R6/lib32/modules/dri\x00/usr/lib32/dri"
      newPaths="/run/opengl-driver-32/lib/dri\x00/dev/null/dri"
      sed -i -e "s|$oldPaths|$newPaths|" \
        $out/lib/xorg/modules/extensions/fglrx/fglrx-libglx.so

      for lib3 in \
        dri/fglrx_dri.so \
        fglrx_dri.so \
        xorg/modules/glesx.so
      do
        oldPaths="/usr/X11R6/lib32/modules/dri/"
        newPaths="/run/opengl-driver-32/lib/dri"
        sed -i -e "s|$oldPaths|$newPaths|" $out/lib/$lib3
      done

      oldPaths="/usr/X11R6/lib32/modules/dri\x00"
      newPaths="/run/opengl-driver-32/lib/dri"
      sed -i -e "s|$oldPaths|$newPaths|" $out/lib/fglrx-libGL.so.1.2

    fi

    for pelib2 in \
      libatiadlxx.so \
      xorg/modules/glesx.so \
      dri/fglrx_dri.so \
      fglrx_dri.so \
      libaticaldd.so
    do
      patchelf --set-rpath $gcc/$lib_arch/ $out/lib/$pelib2
    done

    for p in $extraDRIlibs; do
      for lib in $p/lib/*.so*; do
        ln -s $lib $out/lib/
      done
    done

    rm -f $out/lib/fglrx/switchlibglx && rm -f $out/lib/fglrx/switchlibGL'';

  meta = {
    description = "ATI Radeon™ display driver shared libraries.";
    homepage = http://support.amd.com/us/gpudownload/Pages/index.aspx;
    license = licenses.amd;
    platforms = platforms.linux;
    priority = 4;
  };

}
