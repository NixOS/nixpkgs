{ stdenv, fetchurl, libtool, autoconf, automake, gnum4, linkStatic ? false }:

let
  version = "1.0.6";

  sharedLibrary = !stdenv.isDarwin && !(stdenv ? isStatic)
               && stdenv.system != "i686-cygwin" && !linkStatic;

in stdenv.mkDerivation {
  name = "bzip2-${version}";

  src = fetchurl {
    url = "http://www.bzip.org/${version}/bzip2-${version}.tar.gz";
    sha256 = "1kfrc7f0ja9fdn6j1y6yir6li818npy6217hvr3wzmnmzhs8z152";
  };

  crossAttrs = {
    buildInputs = [ libtool autoconf automake gnum4 ];
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
    postPatch = ''
      sed -i -e '/<sys\\stat\.h>/s|\\|/|' bzip2.c
    '';
    preConfigure = "sh ./autogen.sh";
    # clear native hooks that are not needed with autoconf
    preBuild = "";
    preInstall = "";
    postInstall = "";
  };

  preBuild = stdenv.lib.optionalString sharedLibrary ''
    make -f Makefile-libbz2_so
  '';

  preInstall = stdenv.lib.optionalString sharedLibrary ''
    mkdir -p $out/lib
    mv libbz2.so* $out/lib
    ( cd $out/lib &&
      ln -s libbz2.so.1.0.? libbz2.so &&
      ln -s libbz2.so.1.0.? libbz2.so.1
    )
  '';

  installFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    rm $out/bin/bunzip2* $out/bin/bzcat*
    ln -s bzip2 $out/bin/bunzip2
    ln -s bzip2 $out/bin/bzcat
  '';

  patchPhase = ''
    substituteInPlace Makefile --replace CC=gcc CC=cc
    substituteInPlace Makefile-libbz2_so --replace CC=gcc CC=cc
  '';

  preConfigure = ''
    substituteInPlace Makefile --replace '$(PREFIX)/man' '$(PREFIX)/share/man'
  '';

  makeFlags = stdenv.lib.optional linkStatic "LDFLAGS=-static";

  inherit linkStatic;

  meta = {
    homepage = "http://www.bzip.org";
    description = "high-quality data compression program";

    platforms = stdenv.lib.platforms.all;
    maintainers = [];
  };
}
