{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name = "phrasendrescher-${version}";
  version = "1.0";

  src = fetchurl {
    url = "http://leidecker.info/projects/phrasendrescher/${name}.tar.gz";
    sha256 = "1r0j7ms3i324p6if9cg8i0q900zqfjpvfr8pwj181x8ascysbbf2";
  };

  buildInputs = [ openssl ];

  meta = with stdenv.lib; {
    description = "Cracking tool that finds passphrases of SSH keys";
    homepage = http://leidecker.info/projects/phrasendrescher.shtml;
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ bjornfor ];
  };
}
