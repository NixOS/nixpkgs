{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "0.9";
  name = "light-${version}";
  src = fetchurl {
    url = "https://github.com/haikarainen/light/archive/v${version}.tar.gz";
    sha256 = "1dnzkkg307izvw76gvzsl2vpxd2a1grxg5h82ix505rb9nnmn0d6";
  };

  installPhase = "mkdir -p $out/bin; cp light $out/bin/";

  meta = {
    description = "GNU/Linux application to control backlights";
    homepage = https://haikarainen.github.io/light/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ puffnfresh ];
    platforms = stdenv.lib.platforms.linux;
  };
}
