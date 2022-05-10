{ lib
, stdenv
, fetchurl
, unzip
}:

stdenv.mkDerivation rec {
  pname = "goku";
  version = "0.5.1";

  src = fetchurl {
    url = "https://github.com/yqrashawn/GokuRakuJoudo/releases/download/v${version}/goku.zip";
    sha256 = "7c9304a5b4265575ca154bc0ebc04fcf812d14981775966092946cf82f65c782";
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
