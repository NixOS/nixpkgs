{ lib
, stdenv
, fetchFromGitHub
, file
, openssl
, makeWrapper
, which
, curl
}:

stdenv.mkDerivation rec {
  pname = "check_ssl_cert";
  version = "2.19.0";

  src = fetchFromGitHub {
    owner = "matteocorti";
    repo = "check_ssl_cert";
    rev = "v${version}";
    sha256 = "sha256-HNvchmP975k971EYpDFCqxx8w1Oq/IIEy+r1il0PjmQ=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  makeFlags = [
    "DESTDIR=$(out)/bin"
    "MANDIR=$(out)/share/man"
  ];

  postInstall = ''
    wrapProgram $out/bin/check_ssl_cert \
      --prefix PATH : "${lib.makeBinPath [ openssl file which curl ]}"
  '';

  meta = with lib; {
    description = "Nagios plugin to check the CA and validity of an X.509 certificate";
    homepage = "https://github.com/matteocorti/check_ssl_cert";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
