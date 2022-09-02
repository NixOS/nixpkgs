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
  version = "2.40.0";

  src = fetchFromGitHub {
    owner = "matteocorti";
    repo = "check_ssl_cert";
    rev = "v${version}";
    hash = "sha256-L4ofFpHaC2yygCnzX9N+1BForY0R/FZ1qYScurtm33Y=";
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
    maintainers = with maintainers; [ fab ];
    platforms = platforms.all;
  };
}
