{ stdenv, fetchurl, libtool, autoconf, automake, pkgconfig, gnum4 }:

let
  version = "1.0.6";
in stdenv.mkDerivation {
  name = "bzip2-${version}";

  src = fetchurl {
    url = "http://www.bzip.org/${version}/bzip2-${version}.tar.gz";
    sha256 = "1kfrc7f0ja9fdn6j1y6yir6li818npy6217hvr3wzmnmzhs8z152";
  };

  patches = [
    # original upstream for the autoconf patch is here:
    # http://ftp.suse.com/pub/people/sbrabec/bzip2/for_downstream/bzip2-1.0.6-autoconfiscated.patch
    # but we get the mingw-builds version of the patch, which fixes
    # a few more issues
    (fetchurl {
      url = "https://raw.githubusercontent.com/niXman/mingw-builds/17ae841dcf6e72badad7941a06d631edaf687436/patches/bzip2/bzip2-1.0.6-autoconfiscated.patch";
      sha256 = "1flbd3i8vg9kzq0a712qcg9j2c4ymnqvgd0ldyafpzvbqj1iicnp";
    })
  ];

  patchFlags = "-p0";

  nativeBuildInputs = [ libtool autoconf automake gnum4 pkgconfig ];

  preConfigure = "sh ./autogen.sh";

  crossAttrs = {
    # https://github.com/niXman/mingw-builds/blob/master/patches/bzip2/bzip2-1.0.5-slash.patch
    postPatch = ''
      sed -i -e '/<sys\\stat\.h>/s|\\|/|' bzip2.c
    '';
  };

  meta = {
    homepage = "http://www.bzip.org";
    description = "high-quality data compression program";

    platforms = stdenv.lib.platforms.all;
    maintainers = [];
  };
}
