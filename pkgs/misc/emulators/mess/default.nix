{ stdenv, fetchurl, unzip, pkgconfig, SDL, gtk2, GConf, libGLU_combined
, expat, zlib }:

let

  version = "139";

  mameSrc = fetchurl {
    url = "https://github.com/mamedev/mame/releases/download/mame0139/mame0${version}s.zip";
    sha256 = "1mpkwxfz38cgxzvlni2y3fxas3b8qmnzj2ik2zzbd8mr622jdp79";
  };

  messSrc = fetchurl {
    url = "http://www.progettosnaps.net/MESS/src/mess0${version}s.zip";
    name = "mess0139s.zip";
    sha256 = "1v892cg6wn8cdwc8pf1gcqqdb1v1v295r6jw2hf58svwx3h27xyy";
  };

in

stdenv.mkDerivation {
  name = "mess-0.${version}";

  unpackPhase =
    ''
      unzip ${mameSrc}
      # Yes, the MAME distribution is a zip file containing a zip file...
      unzip mame.zip
      unzip -o ${messSrc}
    '';

  makeFlags = "TARGET=mess BUILD_EXPAT= BUILD_ZLIB= NOWERROR=1";

  buildInputs =
    [ unzip pkgconfig SDL gtk2 GConf libGLU_combined expat zlib ];

  installPhase =
    ''
      mkdir -p $out/bin
      cp mess* $out/bin/mess
    '';

  meta = {
    homepage = https://www.mess.org/;
    license = "non-commercial";
    description = "Multi Emulator Super System, an emulator of many game consoles and computer systems";
    broken = true;
  };
}
