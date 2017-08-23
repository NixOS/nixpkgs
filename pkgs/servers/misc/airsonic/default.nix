{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "airsonic-${version}";
  version = "10.0.0";

  src = fetchurl {
    url = "https://github.com/airsonic/airsonic/releases/download/v${version}/airsonic.war";
    sha256 = "0ldqccdm7z25my0wmispbshnn26l50a61q2ig2yl0krx4lmhfams";
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
