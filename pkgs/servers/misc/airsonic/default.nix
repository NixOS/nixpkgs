{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "airsonic";
  version = "10.4.2";

  src = fetchurl {
    url = "https://github.com/airsonic/airsonic/releases/download/v${version}/airsonic.war";
    sha256 = "15dxrz1vi5h26g4z9p3x9p96hm1swajsfc2i725xbllpkhnykzcx";
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
