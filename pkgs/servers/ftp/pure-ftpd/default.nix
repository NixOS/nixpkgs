{
  lib,
  stdenv,
  fetchurl,
  openssl,
  pam,
  libxcrypt,
}:

stdenv.mkDerivation rec {
  pname = "pure-ftpd";
  version = "1.0.51";

  src = fetchurl {
    url = "https://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-${version}.tar.gz";
    sha256 = "sha256-QWD2a3ZhXuojl+rE6j8KFGt5KCB7ebxMwvma17e9lRM=";
  };

  buildInputs = [
    openssl
    pam
    libxcrypt
  ];

  configureFlags = [ "--with-tls" ];

  meta = with lib; {
    description = "Free, secure, production-quality and standard-conformant FTP server";
    homepage = "https://www.pureftpd.org";
    license = licenses.isc; # with some parts covered by BSD3(?)
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
