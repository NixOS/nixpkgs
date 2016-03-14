{ stdenv, fetchurl, kernel ? null, which
, xorg, makeWrapper, glibc, patchelf, unzip
, fontconfig, freetype, mesa # for fgl_glxgears
, # Whether to build the libraries only (i.e. not the kernel module or
  # driver utils). Used to support 32-bit binaries on 64-bit
  # Linux.
  libsOnly ? false
}:

assert (!libsOnly) -> kernel != null;

with stdenv.lib;

let
  version = "15.7";
in

# This derivation requires a maximum of gcc49, Linux kernel 4.1 and xorg.xserver 1.17
# and will not build or run using versions newer

# If you want to use a different Xorg version probably
# DIR_DEPENDING_ON_XORG_VERSION in builder.sh has to be adopted (?)
# make sure libglx.so of ati is used. xorg.xorgserver does provide it as well
# which is a problem because it doesn't contain the xorgserver patch supporting
# the XORG_DRI_DRIVER_PATH env var.
# See http://thread.gmane.org/gmane.linux.distributions.nixos/4145 for a
# workaround (TODO)

# The gentoo ebuild contains much more "magic" and is usually a great resource to
# find patches XD

# http://wiki.cchtml.com/index.php/Main_Page

# 
# /usr/lib/dri/fglrx_dri.so must point to /run/opengl-driver/lib/fglrx_dri.so
# This is done in the builder script.

stdenv.mkDerivation {

  linuxonly =
    if stdenv.system == "i686-linux" then
      true
    else if stdenv.system == "x86_64-linux" then
      true
    else throw "ati-drivers are Linux only. Sorry. The build was stopped.";

  name = "ati-drivers-${version}" + (optionalString (!libsOnly) "-${kernel.version}");

  builder = ./builder.sh;
  gcc = stdenv.cc.cc;
  libXinerama = xorg.libXinerama;
  libXrandr = xorg.libXrandr;
  libXrender = xorg.libXrender;
  libXxf86vm = xorg.libXxf86vm;
  xf86vidmodeproto = xorg.xf86vidmodeproto;
  libSM = xorg.libSM;
  libICE = xorg.libICE;
  libfreetype = freetype;
  libfontconfig = fontconfig;

  src = fetchurl {
    url = "http://www2.ati.com/drivers/linux/amd-driver-installer-15.20.1046-x86.x86_64.zip";
    sha256 = "ffde64203f49d9288eaa25f4d744187b6f4f14a87a444bab6a001d822b327a9d";
    curlOpts = "--referer http://support.amd.com/en-us/download/desktop?os=Linux%20x86_64";
  };

  patchPhaseSamples = "patch -p2 < ${./patch-samples.patch}";
  patchPhase1 = "patch -p1 < ${./kernel-api-fixes.patch}";

  buildInputs =
    [ xorg.libXrender xorg.libXext xorg.libX11 xorg.libXinerama xorg.libSM
      xorg.libXrandr xorg.libXxf86vm xorg.xf86vidmodeproto xorg.imake xorg.libICE
      patchelf
      unzip
      mesa
      fontconfig
      freetype
      makeWrapper
      which
    ];

  inherit libsOnly;

  kernel = if libsOnly then null else kernel.dev;

  inherit glibc /* glibc only used for setting interpreter */;

  # outputs TODO: probably many fixes are needed;
  # this in particular would be much better by lib.makeLibraryPath
  LD_LIBRARY_PATH = stdenv.lib.concatStringsSep ":"
    [ "${xorg.libXrandr.out}/lib/"
      "${xorg.libXrender.out}/lib/"
      "${xorg.libXext.out}/lib/"
      "${xorg.libX11.out}/lib/"
      "${xorg.libXinerama.out}/lib/"
      "${xorg.libSM.out}/lib/"
      "${xorg.libICE.out}/lib/"
      "${stdenv.cc.cc.out}/lib/"
    ];

  # without this some applications like blender don't start, but they start
  # with nvidia. This causes them to be symlinked to $out/lib so that they
  # appear in /run/opengl-driver/lib which get's added to LD_LIBRARY_PATH

  extraDRIlibs = [ xorg.libXrandr xorg.libXrender xorg.libXext xorg.libX11 xorg.libXinerama xorg.libSM xorg.libICE ];

  inherit mesa; # only required to build the examples

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "ATI Catalyst display drivers";
    homepage = http://support.amd.com/us/gpudownload/Pages/index.aspx;
    license = licenses.unfree;
    maintainers = with maintainers; [ marcweber offline jgeerds ];
    platforms = platforms.linux;
    hydraPlatforms = [];
    # Copied from the nvidia default.nix to prevent a store collision.
    priority = 4;
  };



}
