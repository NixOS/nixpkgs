{ stdenv, fetchurl, kernel ? null, which, imake
, mesa # for fgl_glxgears
, libXxf86vm, xf86vidmodeproto # for fglrx_gamma
, xorg, makeWrapper, glibc, patchelf
, unzip
, qt4 # for amdcccle
, # Whether to build the libraries only (i.e. not the kernel module or
  # driver utils). Used to support 32-bit binaries on 64-bit
  # Linux.
  libsOnly ? false
}:

assert (!libsOnly) -> kernel != null;

# ------------ DROPPED SUPPORT FOR RADEONS HD 5 6 k --------------
# Please note that the radeon-crimson-15.12-15 SADLY :(
# drops support for pre-GCN cards so mainly
# Radeons of series 5000 and 6000
# ----------------------------------------------------------------

# If you want to use a different Xorg version probably
# DIR_DEPENDING_ON_XORG_VERSION in builder.sh has to be adopted (?)
# make sure libglx.so of ati is used. xorg.xorgserver does provide it as well
# which is a problem because it doesn't contain the xorgserver patch supporting
# the XORG_DRI_DRIVER_PATH env var.
# See http://thread.gmane.org/gmane.linux.distributions.nixos/4145 for a
# workaround (TODO)

# The gentoo ebuild contains much more magic and is usually a great resource to
# find patches :)

# http://wiki.cchtml.com/index.php/Main_Page

# 
# /usr/lib/dri/fglrx_dri.so must point to /run/opengl-driver/lib/fglrx_dri.so
# This is done in the builder script.

with stdenv.lib;

stdenv.mkDerivation {
  name = "ati-drivers-15.12" + (optionalString (!libsOnly) "-${kernel.version}");

  builder = ./builder.sh;

  inherit libXxf86vm xf86vidmodeproto;
  gcc = stdenv.cc.cc;

  src = fetchurl {
    url = "http://www2.ati.com/drivers/linux/radeon-crimson-15.12-15.302-151217a-297685e.zip";
    sha256 = "704f2dfc14681f76dae3b4120c87b1ded33cf43d5a1d800b6de5ca292bb61e58";
    curlOpts = "--referer http://support.amd.com/en-us/download/desktop?os=Linux%20x86_64";
  };

  patchPhaseSamples = "patch -p2 < ${./patch-samples.patch}";
# The following patches were found at https://aur.archlinux.org/packages/catalyst
# they provide various fixes and allow catalyst crimson to build past kernel 4.2 to 4.3 at the very least.
  patchPhase1 = "patch -p1 < ${./makefile_compat.patch}";
  patchPhase2 = "patch -p1 < ${./lano1106_kcl_agp_13_4.patch}";
  patchPhase3 = "patch -p1 < ${./lano1106_fglrx_intel_iommu.patch}";
  patchPhase4 = "patch -p1 < ${./grsec_arch.patch}";
  patchPhase5 = "patch -p1 < ${./fglrx_gpl_symbol.patch}";
  patchPhase6 = "patch -p1 < ${./crimson_i686_xg.patch}";
  patchPhase7 = "patch -p1 < ${./4.3-kolasa-seq_printf.patch}";
  patchPhase8 = "patch -p1 < ${./4.3-gentoo-mtrr.patch}";

  buildInputs =
    [ xorg.libXext xorg.libX11 xorg.libXinerama
      xorg.libXrandr which imake makeWrapper
      patchelf
      unzip
      mesa
      qt4
    ];

  inherit libsOnly;

  kernel = if libsOnly then null else kernel.dev;

  inherit glibc /* glibc only used for setting interpreter */;

  LD_LIBRARY_PATH = stdenv.lib.concatStringsSep ":"
    [ "${xorg.libXrandr}/lib"
      "${xorg.libXrender}/lib"
      "${xorg.libXext}/lib"
      "${xorg.libX11}/lib"
      "${xorg.libXinerama}/lib"
#      "${stdenv.cc.cc}/lib"
    ];

  # without this some applications like blender don't start, but they start
  # with nvidia. This causes them to be symlinked to $out/lib so that they
  # appear in /run/opengl-driver/lib which get's added to LD_LIBRARY_PATH
  extraDRIlibs = [ xorg.libXext xorg.libX11 ];

  inherit mesa qt4; # only required to build examples and amdcccle

  meta = with stdenv.lib; {
    description = "ATI drivers";
    homepage = http://support.amd.com/us/gpudownload/Pages/index.aspx;
    license = licenses.unfree;
    maintainers = with maintainers; [ marcweber offline jgeerds ];
    platforms = platforms.linux;
    hydraPlatforms = [];
  };
}
