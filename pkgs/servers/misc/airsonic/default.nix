{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "airsonic";
  version = "10.5.0";

  src = fetchurl {
    url = "https://github.com/airsonic/airsonic/releases/download/v${version}/airsonic.war";
    sha256 = "0nja33x3qh8zylqc7dn6x8j1wyxf7pzf9vdg9rzaq1hl6mi573jq";
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
