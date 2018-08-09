{ stdenv, fetchurl, openssl, libssh2, gpgme }:

stdenv.mkDerivation rec {
  name = "phrasendrescher-${version}";
  version = "1.2.2b";

  src = fetchurl {
    url = "http://leidecker.info/projects/phrasendrescher/${name}.tar.gz";
    sha256 = "0bkiy9dlc1rqicl7g5sbfhgqlyqms4s66lcawwhhbl9d60y72ghs";
  };

  buildInputs = [ openssl libssh2 gpgme ];

  configureFlags = "--with-plugins";

  meta = with stdenv.lib; {
    description = "Cracking tool that finds passphrases of SSH keys";
    homepage = http://leidecker.info/projects/phrasendrescher.shtml;
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ bjornfor ];
  };
}
