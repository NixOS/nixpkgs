{ stdenv, fetchurl, kernel, xlibs, which, imake
, mesa # for fgl_glxgears
, libXxf86vm, xf86vidmodeproto # for fglrx_gamma
, xorg, makeWrapper, glibc, patchelf
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

assert stdenv.system == "x86_64-linux";

stdenv.mkDerivation rec {
  name = "ati-drivers-${version}-${kernel.version}";
  version = "10-11-x86";

  builder = ./builder.sh;

  inherit libXxf86vm xf86vidmodeproto;

  src = fetchurl {
    url = https://www2.ati.com/drivers/linux/ati-driver-installer-10-11-x86.x86_64.run;
    sha256 = "1z33w831ayx1j5lm9d1xv6whkmzsz9v8li3s8c96hwnwki6zpimr";
  };

  buildInputs =
    [ xlibs.libXext xlibs.libX11
      xlibs.libXrandr which imake makeWrapper
      patchelf
    ];
    
  inherit kernel glibc /* glibc only used for setting interpreter */;
  
  LD_LIBRARY_PATH = stdenv.lib.concatStringsSep ":"
    [ "${xorg.libXrandr}/lib"
      "${xorg.libXrender}/lib"
      "${xorg.libXext}/lib"
      "${xorg.libX11}/lib"
    ];

  inherit mesa; # only required to build examples

  meta = {
    description = "ati drivers";
    homepage = http://support.amd.com/us/gpudownload/Pages/index.aspx;
    license = "unfree";
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = [ "x86_64-linux" ];
  };

  # moved assertions here because the name is evaluated when the NixOS manual is generated
  # Don't make that fail - fail lazily when a users tries to build this derivation only
  dummy =
    # assert xorg.xorgserver.name == "xorg-server-1.7.5";
    assert stdenv.system == "x86_64-linux"; # i686-linux should work as well - however I didn't test it.
    null;

}
