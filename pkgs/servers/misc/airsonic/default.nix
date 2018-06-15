{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "airsonic-${version}";
  version = "10.1.1";

  src = fetchurl {
    url = "https://github.com/airsonic/airsonic/releases/download/v${version}/airsonic.war";
    sha256 = "0acj6la88lnbfdp0nilvsll48zfig7sgibgwfjjckialppyg4ir6";
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
