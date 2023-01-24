{ lib
, stdenv
, fetchFromGitHub
, file
, openssl
, makeWrapper
, which
, curl
, bc
, coreutils # date and timeout binary
, bind # host and dig binary
, nmap
, iproute2
, netcat-gnu
, python3
}:

stdenv.mkDerivation rec {
  pname = "check_ssl_cert";
  version = "2.58.0";

  src = fetchFromGitHub {
    owner = "matteocorti";
    repo = "check_ssl_cert";
    rev = "v${version}";
    hash = "sha256-nQE3UMZcIR063JuZkTN49imDYQGGnNzE1yaeR4k4mWY=";
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
      --prefix PATH : "${lib.makeBinPath [ openssl file which curl bc coreutils bind nmap iproute2 netcat-gnu python3 ]}"
  '';

  meta = with lib; {
    description = "Nagios plugin to check the CA and validity of an X.509 certificate";
    homepage = "https://github.com/matteocorti/check_ssl_cert";
    changelog = "https://github.com/matteocorti/check_ssl_cert/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fab ];
    platforms = platforms.all;
  };
}
