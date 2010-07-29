{stdenv, fetchurl, xorg, automake, autoconf, libtool, makeOverridable}:
{
  xf86videoati = {src, suffix}: 
  makeOverridable stdenv.mkDerivation {
      name = "xf86-video-ati-${suffix}";
      buildInputs = xorg.xf86videoati.buildInputs ++
         [autoconf automake libtool];
      builder = ./builder.sh;
      inherit src;
      preConfigure = ''
        export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -DPACKAGE_VERSION_MAJOR=6"
        export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -DPACKAGE_VERSION_MINOR=9"
        export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -DPACKAGE_VERSION_PATCHLEVEL=999"

        sed -e 's/@DRIVER_MAN_SUFFIX@/man/g' -i man/Makefile.am
        export DRIVER_MAN_DIR=$out/share/man/man5 

        ./autogen.sh
      '';
  };
}
