{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "airsonic-${version}";
  version = "10.1.2";

  src = fetchurl {
    url = "https://github.com/airsonic/airsonic/releases/download/v${version}/airsonic.war";
    sha256 = "0hpk801dipmzsswgx0y6m0xhwn5iz97agnb2bzbr5xhkl4a0d33k";
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
