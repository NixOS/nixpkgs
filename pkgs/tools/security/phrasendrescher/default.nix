{ stdenv, fetchurl, openssl, libssh2, gpgme }:

stdenv.mkDerivation rec {
  pname = "phrasendrescher";
  version = "1.2.2c";

  src = fetchurl {
    url = "http://leidecker.info/projects/${pname}/${pname}-${version}.tar.gz";
    sha256 = "18vg6h294219v14x5zqm8ddmq5amxlbz7pw81lcmpz8v678kwyph";
  };

  postPatch = ''
    substituteInPlace configure \
      --replace 'SSL_LIB="ssl"' 'SSL_LIB="crypto"'
  '';

  buildInputs = [ openssl libssh2 gpgme ];

  configureFlags = "--with-plugins";

  meta = with stdenv.lib; {
    description = "A modular and multi processing pass phrase cracking tool";
    homepage = "http://leidecker.info/projects/phrasendrescher/index.shtml";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ bjornfor ];
  };
}
