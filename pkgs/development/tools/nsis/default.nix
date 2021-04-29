{ lib
, stdenv
, symlinkJoin
, fetchurl
, fetchzip
, sconsPackages
, zlib
, libiconv
}:

stdenv.mkDerivation rec {
  pname = "nsis";
  version = "3.06.1";

  src =
    fetchurl {
      url = "mirror://sourceforge/project/nsis/NSIS%203/${version}/nsis-${version}-src.tar.bz2";
      sha256 = "1w1z2m982l6j8lw8hy91c3979wbnqglcf4148f9v79vl32znhpcv";
    };
  srcWinDistributable =
    fetchzip {
      url = "mirror://sourceforge/project/nsis/NSIS%203/${version}/nsis-${version}.zip";
      sha256 = "04qm9jqbcybpwcrjlksggffdyafzwxxcaz9xhjw8w5rb95x7lw5q";
    };

  postUnpack = ''
    mkdir -p $out/share/nsis
    cp -avr ${srcWinDistributable}/{Contrib,Include,Plugins,Stubs} \
      $out/share/nsis
    chmod -R u+w $out/share/nsis
  '';

  nativeBuildInputs = [ sconsPackages.scons_3_1_2 ];
  buildInputs = [ zlib ] ++ lib.optionals stdenv.isDarwin [ libiconv ];

  CPPPATH = symlinkJoin {
     name = "nsis-includes";
     paths = [ zlib.dev ] ++ lib.optionals stdenv.isDarwin [ libiconv ];
  };

  LIBPATH = symlinkJoin {
    name = "nsis-libs";
    paths = [ zlib ] ++ lib.optionals stdenv.isDarwin [ libiconv ];
  };

  sconsFlags = [
    "SKIPSTUBS=all"
    "SKIPPLUGINS=all"
    "SKIPUTILS=all"
    "SKIPMISC=all"
    "NSIS_CONFIG_CONST_DATA=no"
  ] ++ lib.optional stdenv.isDarwin "APPEND_LINKFLAGS=-liconv";

  preBuild = ''
    sconsFlagsArray+=(
      "PATH=$PATH"
      "CC=$CC"
      "CXX=$CXX"
      "APPEND_CPPPATH=$CPPPATH/include"
      "APPEND_LIBPATH=$LIBPATH/lib"
    )
  '';

  prefixKey = "PREFIX=";
  installTargets = [ "install-compiler" ];

  meta = with lib; {
    description = "A free scriptable win32 installer/uninstaller system that doesn't suck and isn't huge";
    homepage = "https://nsis.sourceforge.io/";
    license = licenses.zlib;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pombeirp ];
  };
}
