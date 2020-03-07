{ stdenv, fetchurl,
	openssl,
 } :

stdenv.mkDerivation rec {
  version = "20191016";
  pname = "mbuffer";

  src = fetchurl {
    url = "http://www.maier-komor.de/software/mbuffer/mbuffer-${version}.tgz";
    sha256 = "05xyvmbs2x5gbj2njgg7hsj3alb5dh96xhab0w0qkhb58x2i1hld";
  };

  buildInputs = [ openssl ];
  doCheck = true;

  meta = {
    homepage = "http://www.maier-komor.de/mbuffer.html";
    description  = "A tool for buffering data streams with a large set of unique features";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ tokudan ];
    platforms = stdenv.lib.platforms.linux; # Maybe other non-darwin Unix
  };
}
