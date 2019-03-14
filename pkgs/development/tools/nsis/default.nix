{ stdenv, symlinkJoin, fetchurl, fetchzip, scons, zlib }:

let
  ZLIB_HOME = symlinkJoin { name="zlib-wrap"; paths = [ zlib zlib.dev ]; };

in stdenv.mkDerivation rec {
  name = "nsis-${version}";
  version = "3.04";

  src =
    fetchurl {
      url = "https://vorboss.dl.sourceforge.net/project/nsis/NSIS%203/${version}/nsis-${version}-src.tar.bz2";
      sha256 = "1xgllk2mk36ll2509hd31mfq6blgncmdzmwxj3ymrwshdh23d5b0";
    };
  srcWinDistributable =
    fetchzip {
      url = "https://vorboss.dl.sourceforge.net/project/nsis/NSIS%203/${version}/nsis-${version}.zip";
      sha256 = "1g31vz73x4d3cmsw2wfk43qa06bpqp5815fb5qq9vmwms6hym6y2";
    };

  postUnpack = ''
    mkdir -p $out/share/nsis
    cp -avr ${srcWinDistributable}/{Contrib,Include,Plugins,Stubs} \
      $out/share/nsis
  '';

  nativeBuildInputs = [ scons ];
  buildInputs = [ zlib ];

  sconsFlags = [
    "SKIPSTUBS=all"
    "SKIPPLUGINS=all"
    "SKIPUTILS=all"
    "SKIPMISC=all"
    "APPEND_CPPPATH=${ZLIB_HOME}/include"
    "APPEND_LIBPATH=${ZLIB_HOME}/lib"
    "NSIS_CONFIG_CONST_DATA=no"
    "STRIP=no"
  ];

  preBuild = ''
    sconsFlagsArray+=("PATH=$PATH")
  '';

  prefixKey = "PREFIX=";
  installTargets = "install-compiler";

  dontStrip = true;

  meta = with stdenv.lib; {
    description = "NSIS is a free scriptable win32 installer/uninstaller system that doesn't suck and isn't huge";
    homepage = https://nsis.sourceforge.io/;
    license = licenses.zlib;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pombeirp ];
  };
}
