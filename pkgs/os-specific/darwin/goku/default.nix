{ lib
, stdenv
, fetchurl
, unzip
}:

stdenv.mkDerivation rec {
  pname = "goku";
  version = "0.5.2";

  src = fetchurl {
    url = "https://github.com/yqrashawn/GokuRakuJoudo/releases/download/v${version}/goku.zip";
    sha256 = "506eccdabedc68c112778b13ded65099327267c2e3fd488916e3a340bc312954";
  };

  nativeBuildInputs = [
    unzip
  ];

  sourceRoot = ".";

  installPhase = ''
    chmod +x goku
    chmod +x gokuw
    mkdir -p $out/bin
    cp goku $out/bin
    cp gokuw $out/bin
  '';

  meta = with lib; {
    description = "Karabiner configurator";
    homepage = "https://github.com/yqrashawn/GokuRakuJoudo";
    license = licenses.gpl3;
    maintainers = [ maintainers.nikitavoloboev ];
    platforms = platforms.darwin;
  };
}
