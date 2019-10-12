{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "airsonic";
  version = "10.4.0";

  src = fetchurl {
    url = "https://github.com/airsonic/airsonic/releases/download/v${version}/airsonic.war";
    sha256 = "1m4l10hp5m010ljsvn2ba4bbh8i26d04xffw81gfgjw08gya2hh8";
  };

  buildCommand = ''
    mkdir -p "$out/webapps"
    cp "$src" "$out/webapps/airsonic.war"
  '';

  meta = with stdenv.lib; {
    description = "Personal media streamer";
    homepage = https://airsonic.github.io;
    license = stdenv.lib.licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ disassembler ];
  };
}
