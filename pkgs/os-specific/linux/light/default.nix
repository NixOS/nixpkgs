{ stdenv, fetchurl, help2man }:

stdenv.mkDerivation rec {
  version = "1.0";
  name = "light-${version}";
  src = fetchurl {
    url = "https://github.com/haikarainen/light/archive/v${version}.tar.gz";
    sha256 = "974608ee42ffe85cfd23184306d56d86ec4e6f4b0518bafcb7b3330998b1af64";
  };
  buildInputs = [ help2man ];

  installPhase = "mkdir -p $out/bin; cp light $out/bin/";

  preFixup = "make man; mkdir -p $out/man/man1; mv light.1.gz $out/man/man1";

  meta = {
    description = "GNU/Linux application to control backlights";
    homepage = https://haikarainen.github.io/light/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ puffnfresh ];
    platforms = stdenv.lib.platforms.linux;
  };
}
