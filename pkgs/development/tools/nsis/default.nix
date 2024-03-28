{ lib
, stdenv
, symlinkJoin
, fetchurl
, fetchzip
, scons
, zlib
, libiconv
}:

stdenv.mkDerivation rec {
  pname = "nsis";
  version = "3.09";

  src =
    fetchurl {
      url = "mirror://sourceforge/project/nsis/NSIS%203/${version}/nsis-${version}-src.tar.bz2";
      sha256 = "0cd846c6e9c59068020a87bfca556d4c630f2c5d554c1098024425242ddc56e2";
    };
  srcWinDistributable =
    fetchzip {
      url = "mirror://sourceforge/project/nsis/NSIS%203/${version}/nsis-${version}.zip";
      sha256 = "f5dc52eef1f3884230520199bac6f36b82d643d86b003ce51bd24b05c6ba7c91";
    };

  postUnpack = ''
    mkdir -p $out/share/nsis
    cp -avr ${srcWinDistributable}/{Contrib,Include,Plugins,Stubs} \
      $out/share/nsis
    chmod -R u+w $out/share/nsis
  '';

  nativeBuildInputs = [ scons ];
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
    mainProgram = "makensis";
    broken = stdenv.isDarwin;
  };
}
