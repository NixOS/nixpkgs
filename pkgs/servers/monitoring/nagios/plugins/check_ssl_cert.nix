{ lib
, stdenv
, bc
, bind # host and dig binary
, coreutils # date and timeout binary
, curl
, fetchFromGitHub
, file
, iproute2
, makeWrapper
, netcat-gnu
, nmap
, openssl
, python3
, which
}:

stdenv.mkDerivation rec {
  pname = "check_ssl_cert";
<<<<<<< HEAD
  version = "2.72.0";
=======
  version = "2.68.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "matteocorti";
    repo = "check_ssl_cert";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-0FKxZL+PY9cU64OzzfoxaHv6/neAJPwqOKcBsiSY3dw=";
=======
    hash = "sha256-yigg2C1FkdS/O+GCAkbQhXwARO0583V8MREzVCNsoGA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
