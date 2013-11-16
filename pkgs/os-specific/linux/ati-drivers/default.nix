{ stdenv, fetchurl, kernelDev, xlibs, which, imake
, mesa # for fgl_glxgears
, libXxf86vm, xf86vidmodeproto # for fglrx_gamma
, xorg, makeWrapper, glibc, patchelf
, unzip
}:

# If you want to use a different Xorg version probably
# DIR_DEPENDING_ON_XORG_VERSION in builder.sh has to be adopted (?)
# make sure libglx.so of ati is used. xorg.xorgserver does provide it as well
# which is a problem because it doesn't contain the xorgserver patch supporting
# the XORG_DRI_DRIVER_PATH env var.
# See http://thread.gmane.org/gmane.linux.distributions.nixos/4145 for a
# workaround (TODO)

# The gentoo ebuild contains much more magic..

# http://wiki.cchtml.com/index.php/Main_Page

# There is one issue left:
# /usr/lib/dri/fglrx_dri.so must point to /run/opengl-driver/lib/fglrx_dri.so

assert stdenv.system == "x86_64-linux";

stdenv.mkDerivation rec {
  name = "ati-drivers-${version}-${kernel.version}";
  version = "13.4";

  builder = ./builder.sh;

  inherit libXxf86vm xf86vidmodeproto;

  src = fetchurl {
    url = http://www2.ati.com/drivers/linux/amd-driver-installer-catalyst-13-4-linux-x86.x86_64.zip;
    sha256 = "1914ikdich0kg047bqh89ai5z4dyryj5mlw5i46n90fsfiaxa532";
  };

  patchPhase = "patch -p0 < ${./gentoo-patches.patch}";

  buildInputs =
    [ xlibs.libXext xlibs.libX11
      xlibs.libXrandr which imake makeWrapper
      patchelf
      unzip
      mesa
    ];

  kernel = kernelDev;

  inherit glibc /* glibc only used for setting interpreter */;

  LD_LIBRARY_PATH = stdenv.lib.concatStringsSep ":"
    [ "${xorg.libXrandr}/lib"
      "${xorg.libXrender}/lib"
      "${xorg.libXext}/lib"
      "${xorg.libX11}/lib"
    ];

  # without this some applications like blender don't start, but they start
  # with nvidia. This causes them to be symlinked to $out/lib so that they
  # appear in /run/opengl-driver/lib which get's added to LD_LIBRARY_PATH
 extraDRIlibs = [ xorg.libXext ];

  inherit mesa; # only required to build examples

  meta = {
    description = "ATI drivers";
    homepage = http://support.amd.com/us/gpudownload/Pages/index.aspx;
    license = "unfree";
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = [ "x86_64-linux" ];
    hydraPlatforms = [];
  };

  # moved assertions here because the name is evaluated when the NixOS manual is generated
  # Don't make that fail - fail lazily when a users tries to build this derivation only
  dummy =
    # assert xorg.xorgserver.name == "xorg-server-1.7.5";
    assert stdenv.system == "x86_64-linux"; # i686-linux should work as well - however I didn't test it.
    null;

}
