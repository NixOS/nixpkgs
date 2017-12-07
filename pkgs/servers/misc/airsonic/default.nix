{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "airsonic-${version}";
  version = "10.0.1";

  src = fetchurl {
    url = "https://github.com/airsonic/airsonic/releases/download/v${version}/airsonic.war";
    sha256 = "1qky8dz49200f6100ivkn5g7i0hzkv3gpq2r0cj6z53s8d1ayblc";
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
