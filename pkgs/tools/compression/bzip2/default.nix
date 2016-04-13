{ stdenv, fetchurl, libtool, autoconf, automake, gnum4, linkStatic ? false }:

let
  version = "1.0.6";

  sharedLibrary = !(stdenv ? isStatic)
               && stdenv.system != "i686-cygwin" && !linkStatic;

  darwinMakefile = fetchurl {
    url    = "https://gitweb.gentoo.org/repo/proj/prefix.git/plain/app-arch/bzip2/files/bzip2-1.0.6-Makefile-libbz2_dylib";
    sha256 = "1lq6g98kfpwv2f7wn4sk8hzcf87dwf92gviq0b4691f5bvc9mawz";
  };
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

  outputs = [ "dev" "bin" "static" ] ++ stdenv.lib.optional sharedLibrary "out";

  preBuild = stdenv.lib.optionalString sharedLibrary ''
    make -f ${if stdenv.isDarwin then "Makefile-libbz2_dylib" else "Makefile-libbz2_so"}
  '';

  preInstall = stdenv.lib.optionalString sharedLibrary (if !stdenv.isDarwin then ''
    mkdir -p $out/lib
    mv libbz2.so* $out/lib
    ( cd $out/lib &&
      ln -s libbz2.so.1.0.? libbz2.so &&
      ln -s libbz2.so.1.0.? libbz2.so.1
    )
  '' else ''
    mkdir -p $out/lib
    mv libbz2.*.dylib $out/lib
    ( cd $out/lib &&
      ln -s libbz2.1.0.?.dylib libbz2.dylib &&
      ln -s libbz2.1.0.?.dylib libbz2.1.dylib
    )
  '');

  installFlags = [ "PREFIX=$(bin)" ];

  postInstall = ''
    rm $bin/bin/bunzip2* $bin/bin/bzcat*
    ln -s bzip2 $bin/bin/bunzip2
    ln -s bzip2 $bin/bin/bzcat

    mkdir "$static"
    mv "$bin/lib" "$static/"
  '';

  postPatch = ''
    substituteInPlace Makefile --replace CC=gcc CC=cc
    substituteInPlace Makefile-libbz2_so --replace CC=gcc CC=cc
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    cp ${darwinMakefile} Makefile-libbz2_dylib
    substituteInPlace Makefile-libbz2_dylib \
      --replace "CC=gcc" "CC=cc" \
      --replace "PREFIX=/usr" "PREFIX=$out"
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
