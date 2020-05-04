{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "airsonic";
  version = "10.6.1";

  src = fetchurl {
    url = "https://github.com/airsonic/airsonic/releases/download/v${version}/airsonic.war";
    sha256 = "0dgk9i7981wydp44zax21y48psybcsd4i68cmlp9izl8aa5gk2vb";
  };

  buildCommand = ''
    mkdir -p "$out/webapps"
    cp "$src" "$out/webapps/airsonic.war"
  '';

  meta = with stdenv.lib; {
    description = "Personal media streamer";
    homepage = "https://airsonic.github.io";
    license = stdenv.lib.licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ disassembler ];
  };
}
