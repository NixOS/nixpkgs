{ stdenv, lib, fetchurl, kernel ? null, which
, xorg, makeWrapper, glibc, patchelf, unzip
, fontconfig, freetype, libGLU_combined # for fgl_glxgears
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
# See https://marc.info/?l=nix-dev&m=139641585515351 for a
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
    if stdenv.hostPlatform.system == "i686-linux" then
      true
    else if stdenv.hostPlatform.system == "x86_64-linux" then
      true
    else throw "ati-drivers are Linux only. Sorry. The build was stopped.";

  name = pname + "-" + version + (optionalString (!libsOnly) "-${kernelDir.version}");

  builder = ./builder.sh;
  gcc = stdenv.cc.cc;
  libXinerama = xorg.libXinerama;
  libXrandr = xorg.libXrandr;
  libXrender = xorg.libXrender;
  libXxf86vm = xorg.libXxf86vm;
  xorgproto = xorg.xorgproto;
  libSM = xorg.libSM;
  libICE = xorg.libICE;
  libfreetype = freetype;
  libfontconfig = fontconfig;
  libStdCxx = stdenv.cc.cc.lib;

  src = fetchurl {
    url =
    "https://www2.ati.com/drivers/linux/radeon-crimson-15.12-15.302-151217a-297685e.zip";
    sha256 = "704f2dfc14681f76dae3b4120c87b1ded33cf43d5a1d800b6de5ca292bb61e58";
    curlOpts = "--referer https://www.amd.com/en/support";
  };

  hardeningDisable = [ "pic" "format" ];

  patchPhaseSamples = "patch -p2 < ${./patches/patch-samples.patch}";
  patches = [
    ./patches/15.12-xstate-fp.patch
    ./patches/15.9-kcl_str.patch
    ./patches/15.9-mtrr.patch
    ./patches/15.9-preempt.patch
    ./patches/15.9-sep_printf.patch ]
  ++ optionals ( kernel != null &&
                 (lib.versionAtLeast kernel.version "4.6") )
               [ ./patches/kernel-4.6-get_user_pages.patch
                 ./patches/kernel-4.6-page_cache_release-put_page.patch ]
  ++ optionals ( kernel != null &&
                 (lib.versionAtLeast kernel.version "4.7") )
               [ ./patches/4.7-arch-cpu_has_pge-v2.patch ]
  ++ optionals ( kernel != null &&
                 (lib.versionAtLeast kernel.version "4.9") )
               [ ./patches/4.9-get_user_pages.patch ];

  buildInputs =
    [ xorg.libXrender xorg.libXext xorg.libX11 xorg.libXinerama xorg.libSM
      xorg.libXrandr xorg.libXxf86vm xorg.xorgproto xorg.imake xorg.libICE
      patchelf
      unzip
      libGLU_combined
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
      xorg.libXrandr xorg.libXxf86vm xorg.xorgproto xorg.imake xorg.libICE
      libGLU_combined
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

  inherit libGLU_combined; # only required to build the examples

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "ATI Catalyst display drivers";
    homepage = http://support.amd.com/us/gpudownload/Pages/index.aspx;
    license = licenses.unfree;
    maintainers = with maintainers; [ marcweber offline jgeerds jerith666 ];
    platforms = platforms.linux;
    hydraPlatforms = [];
    # Copied from the nvidia default.nix to prevent a store collision.
    priority = 4;
  };

}
