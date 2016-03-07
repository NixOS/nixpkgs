{
stdenv, fetchurl, which, xorg, makeWrapper, glibc
, patchelf, unzip, fontconfig, freetype, kernel ? null
,procps ,amd-non-free-libs
# Enable lock debugging ?
,developer ? false
}:

assert kernel != null;
with stdenv.lib;

# This driver supports Radeon™ R9 200, R7 200, HD 7000, HD 6000, and HD 5000 Series cards.
# You will require amdgpu instead if you have a newer card.
# This derivation requires a maximum of gcc5, Linux kernel 4.4 and xorg.xserver 1.17
# and will not build or run using versions newer.
# This driver does not support an i686-linux NixOS system. However the 32bit libs
# (for running 32 binaries in 64 bit user space are provided.)
# use nixpkgs.config.amd-non-free.developer = true; to enable lock debugging.

let
  version = "15.12";
in

# /usr/lib/dri/fglrx_dri.so must point to /run/opengl-driver/lib/fglrx_dri.so

stdenv.mkDerivation {

  name = "amd-non-free-${version}-${kernel.version}";

  src = fetchurl {
    url = "http://www2.ati.com/drivers/linux/radeon-crimson-${version}-15.302-151217a-297685e.zip";
    curlOpts = "--referer http://support.amd.com/en-us/download/desktop?os=Linux%20x86_64";
    sha256 = "704f2dfc14681f76dae3b4120c87b1ded33cf43d5a1d800b6de5ca292bb61e58";
  };

  inherit glibc /* glibc only used for setting interpreter */;
  dontStrip = true;
  whichBin = which;
  pidofBin = procps;
  dontPatchELF = true;
  preferLocalBuild = true;
  enableParallelBuilding = true;
  # Variables for the module build script etc.
  gcc = stdenv.cc.cc;
  xauth = xorg.xauth;
  libSM = xorg.libSM;
  libICE = xorg.libICE;
  libfreetype = freetype;
  libfontconfig = fontconfig;
  libXrandr = xorg.libXrandr;
  libXrender = xorg.libXrender;
  libXxf86vm = xorg.libXxf86vm;
  libXinerama = xorg.libXinerama;
  kernel = kernel.dev;
  xf86vidmodeproto = xorg.xf86vidmodeproto;
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
    xorg.xf86vidmodeproto xorg.imake xorg.libICE patchelf unzip fontconfig freetype makeWrapper
    which procps
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

  phases = [  "unpackPhase" "patchPhase" "preBuild" "buildPhase" "fixupPhase" ];
 
  preUnpack = "die(){ echo $@; exit 1; }";
  postUnpack = "sh fglrx*/amd-driver-installer-* --extract .";
  prePatch = ''cd ..'';

  patches = [
    ./4.4-manjaro-xstate.patch  ./grsec_arch.patch ./makefile_compat.patch ./lano1106_kcl_agp_13_4.patch
    ./lano1106_fglrx_intel_iommu.patch ./crimson_i686_xg.patch ./4.3-kolasa-seq_printf.patch
    ./4.3-gentoo-mtrr.patch ./display-managers.patch
  ];

  preBuild = if (developer) then ''
    substituteInPlace $TMP/common/lib/modules/fglrx/build_mod/firegl_public.c --replace "Proprietary." "GPL\0Proprietary."
    echo "Lock debugging enabled." ''
  else ''echo "Lock debugging disabled." '';

  buildPhase = ''
    source ${./module.sh}
    substituteInPlace $TMP/common/etc/ati/authatieventsd.sh --replace "/usr/bin:/usr/X11R6/bin" "$xauth/bin/"
    for d1 in \
      $out/bin \
      $out/share/ati
    do
      mkdir -p $d1
    done
    for d2 in \
      $TMP/common/etc \
      $TMP/common/usr/share
    do
      cp -r $d2 $out
    done
    BIN=$TMP/arch/$arch/usr/X11R6/bin
    # patch and copy statically linked qt libs used by amdcccle
    patchelf --set-interpreter $(echo $glibc/lib/ld-linux-x86-64.so.2) $TMP/arch/$arch/usr/share/ati/$lib_arch/libQtCore.so.4 &&
    patchelf --set-rpath $gcc/$lib_arch/ $TMP/arch/$arch/usr/share/ati/$lib_arch/libQtCore.so.4 &&
    patchelf --set-rpath $gcc/$lib_arch/:$out/share/ati/:$libXrender/lib/:$libSM/lib/:$libICE/lib/:$libfontconfig/lib/:$libfreetype/lib/ $TMP/arch/$arch/usr/share/ati/$lib_arch/libQtGui.so.4 &&
    patchelf --set-rpath $gcc/$lib_arch/:$out/share/ati/:$libXinerama/lib/:$libXrandr/lib/ $TMP/arch/$arch/usr/X11R6/bin/amdcccle &&
    patchelf --set-rpath $libXrender/lib/:$libXrandr/lib/ $TMP/arch/$arch/usr/X11R6/bin/aticonfig &&
    patchelf --shrink-rpath $BIN/amdcccle
    # copy binaries and wrap them:
    for prog in $BIN/*; do
      cp -f $prog $out/bin &&
      patchelf --set-interpreter $(echo $glibc/lib/ld-linux-x86-64.so.2) $out/bin/$(basename $prog) &&
      wrapProgram $out/bin/$(basename $prog) --prefix LD_LIBRARY_PATH : $out/lib/:$gcc/lib/:$out/share/ati/:$libfontconfig/lib/:$libfreetype/lib/:$LD_LIBRARY_PATH
    done
    for d3 in \
      $TMP/common/usr/X11R6/bin/* \
      $TMP/arch/$arch/usr/sbin/atieventsd
    do
      cp -f $d3 $out/bin/
    done
    patchelf --set-interpreter $(echo $glibc/lib/ld-linux-x86-64.so.2) $out/bin/atieventsd &&
    wrapProgram $out/bin/atieventsd --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib/:$out/lib/:$gcc/lib/:$out/share/ati/:$libfontconfig/lib/:$libfreetype/lib/:$LD_LIBRARY_PATH \
      --prefix PATH : $whichBin/bin:$pidofBin/bin:$xauth/bin
    cp -r $TMP/arch/$arch/usr/share/ati/$lib_arch/* $out/share/ati/ '';

  meta = {
    description = "ATI Radeon™ display driver kernel module and apps.";
    homepage = http://support.amd.com/us/gpudownload/Pages/index.aspx;
    license = licenses.amd;
    platforms = platforms.linux;
  };

}
