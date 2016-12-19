{ stdenv, fetchurl,
	openssl,
 } :

stdenv.mkDerivation rec {
  version = "20160613";
  name = "mbuffer-${version}";

  src = fetchurl {
    url = "http://www.maier-komor.de/software/mbuffer/mbuffer-${version}.tgz";
    sha256 = "1za9yqfn23axnp4zymdsrjkqcci3wxywqw3bv4dxms57q1ljiab7";
  };

  buildInputs = [ openssl ];

  meta = {
    homepage = http://www.maier-komor.de/mbuffer.html;
    description  = "mbuffer is a tool for buffering data streams with a large set of unique features";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ tokudan ];
    platforms = with stdenv.lib.platforms; allBut darwin;
  };
}
