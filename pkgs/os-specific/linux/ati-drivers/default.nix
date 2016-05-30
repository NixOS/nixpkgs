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

# /usr/lib/dri/fglrx_dri.so must point to /run/opengl-driver/lib/fglrx_dri.so
# This is done in the builder script.

stdenv.mkDerivation rec {

  version = "15.12";
  pname = "ati-drivers";
  build = "15.302";

  linuxonly =
    if stdenv.system == "i686-linux" then
      true
    else if stdenv.system == "x86_64-linux" then
      true
    else throw "ati-drivers are Linux only. Sorry. The build was stopped.";

  name = pname + "-" + version + (optionalString (!libsOnly) "-${kernelDir.version}");

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
  libStdCxx = stdenv.cc.cc.lib;

  src = fetchurl {
    url =
    "https://www2.ati.com/drivers/linux/radeon-crimson-15.12-15.302-151217a-297685e.zip";
    sha256 = "0n0ynqmjkjp5dl5q07as7ps3rlyyn63hq4mlwgd7c7v82ky2skvh";
    curlOpts = "--referer http://support.amd.com/en-us/download/desktop?os=Linux+x86_64";
  };

  patchPhaseSamples = "patch -p2 < ${./patches/patch-samples.patch}";
  patches = [
    ./patches/15.12-xstate-fp.patch
    ./patches/15.9-kcl_str.patch
    ./patches/15.9-mtrr.patch
    ./patches/15.9-preempt.patch
    ./patches/15.9-sep_printf.patch
  ];

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

  kernelDir = if libsOnly then null else kernel.dev;

  # glibc only used for setting the binaries interpreter
  glibcDir = glibc.out;

  # outputs TODO: probably many fixes are needed;
  LD_LIBRARY_PATH = makeLibraryPath
    [ xorg.libXrender xorg.libXext xorg.libX11 xorg.libXinerama xorg.libSM
      xorg.libXrandr xorg.libXxf86vm xorg.xf86vidmodeproto xorg.imake xorg.libICE
      mesa
      fontconfig
      freetype
      stdenv.cc.cc
    ];

  # without this some applications like blender don't start, but they start
  # with nvidia. This causes them to be symlinked to $out/lib so that they
  # appear in /run/opengl-driver/lib which get's added to LD_LIBRARY_PATH

  extraDRIlibs = [ xorg.libXrandr.out xorg.libXrender.out xorg.libXext.out
                   xorg.libX11.out xorg.libXinerama.out xorg.libSM.out
                   xorg.libICE.out ];

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
