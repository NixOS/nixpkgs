{ stdenv, fetchurl,
	openssl,
 } :

stdenv.mkDerivation rec {
  version = "20190127";
  name = "mbuffer-${version}";

  src = fetchurl {
    url = "http://www.maier-komor.de/software/mbuffer/mbuffer-${version}.tgz";
    sha256 = "1p7d9jaiyqcg5q14hlcji6llhjqkg6izc9cfz23jwgq8z2a6zjy5";
  };

  buildInputs = [ openssl ];

  meta = {
    homepage = http://www.maier-komor.de/mbuffer.html;
    description  = "A tool for buffering data streams with a large set of unique features";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ tokudan ];
    platforms = stdenv.lib.platforms.linux; # Maybe other non-darwin Unix
  };
}
