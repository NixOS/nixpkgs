{stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "goku";
  version = "0.1.11";

  src = fetchurl {
    url = "https://github.com/yqrashawn/GokuRakuJoudo/releases/download/v${version}/goku.tar.gz";
    sha256 = "49562342be114c2656726c5c697131acd286965ab3903a1a1e157cc689e20b15";
  };

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/bin
    cp goku $out/bin
    cp gokuw $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Karabiner configurator";
    homepage = https://github.com/yqrashawn/GokuRakuJoudo;
    license = licenses.gpl3;
    maintainers = [ maintainers.nikitavoloboev ];
    platforms = platforms.darwin;
  };
}
