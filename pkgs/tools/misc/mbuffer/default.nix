{ stdenv, fetchurl,
	openssl,
 } :

stdenv.mkDerivation rec {
  version = "20190725";
  pname = "mbuffer";

  src = fetchurl {
    url = "http://www.maier-komor.de/software/mbuffer/mbuffer-${version}.tgz";
    sha256 = "1hjhyh3q0q22czq3s2wk5mcky1jrq9xw8fppw6r7cix1riq74m91";
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
