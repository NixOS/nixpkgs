{lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "goku";
  version = "0.3.6";

  src = fetchurl {
    url = "https://github.com/yqrashawn/GokuRakuJoudo/releases/download/v${version}/goku.tar.gz";
    sha256 = "1pss1k2slbqzpfynik50pdk4jsaiag4abhmr6kadmaaj18mfz7ai";
  };

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
