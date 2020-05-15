{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "airsonic";
  version = "10.6.2";

  src = fetchurl {
    url = "https://github.com/airsonic/airsonic/releases/download/v${version}/airsonic.war";
    sha256 = "0q3qnqymj3gaa6n79pvbyidn1ga99lpngp5wvhlw1aarg1m7vccl";
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
