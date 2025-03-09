{
  bc,
  bind,
  coreutils,
  curl,
  fetchFromGitHub,
  file,
  iproute2,
  lib,
  makeWrapper,
  netcat-gnu,
  nmap,
  openssl,
  python3,
  stdenv,
  which,
}:

stdenv.mkDerivation rec {
  pname = "check_ssl_cert";
  version = "2.87.1";

  src = fetchFromGitHub {
    owner = "matteocorti";
    repo = "check_ssl_cert";
    tag = "v${version}";
    hash = "sha256-pEMCYqPtk+18uNVUxRQ4awrRMuCqrQ6G8Ds6m3lhL9w=";
  };

  nativeBuildInputs = [ makeWrapper ];

  makeFlags = [
    "DESTDIR=$(out)/bin"
    "MANDIR=$(out)/share/man"
  ];

  postInstall = ''
    wrapProgram $out/bin/check_ssl_cert \
      --prefix PATH : "${
        lib.makeBinPath (
          [
            bc
            bind # host and dig binary
            coreutils # date and timeout binary
            curl
            file
            netcat-gnu
            nmap
            openssl
            python3
            which
          ]
          ++ lib.optional stdenv.hostPlatform.isLinux iproute2
        )
      }"
  '';

  meta = {
    changelog = "https://github.com/matteocorti/check_ssl_cert/releases/tag/v${version}";
    description = "Nagios plugin to check the CA and validity of an X.509 certificate";
    homepage = "https://github.com/matteocorti/check_ssl_cert";
    license = lib.licenses.gpl3Plus;
    mainProgram = "check_ssl_cert";
    maintainers = with lib.maintainers; [ fab ];
    platforms = lib.platforms.all;
  };
}
