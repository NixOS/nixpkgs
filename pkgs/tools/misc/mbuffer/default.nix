{ stdenv, fetchurl,
	openssl,
 } :

stdenv.mkDerivation rec {
  version = "20170806";
  name = "mbuffer-${version}";

  src = fetchurl {
    url = "http://www.maier-komor.de/software/mbuffer/mbuffer-${version}.tgz";
    sha256 = "0kbvxrd1k0509whgyl7w20cmqn5q16vjjh7d9glpl2j4lfd66ljw";
  };

  buildInputs = [ openssl ];

  meta = {
    homepage = http://www.maier-komor.de/mbuffer.html;
    description  = "A tool for buffering data streams with a large set of unique features";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ tokudan ];
    platforms = with stdenv.lib.platforms; allBut darwin;
  };
}
