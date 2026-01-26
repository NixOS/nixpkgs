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
  gnugrep,
  gnused,
  net-tools,
  gawk,
}:

stdenv.mkDerivation rec {
  pname = "check_ssl_cert";
  version = "2.94.0";

  src = fetchFromGitHub {
    owner = "matteocorti";
    repo = "check_ssl_cert";
    tag = "v${version}";
    hash = "sha256-t1bgW8a4g289nn34c4xnIyus7aAkZUII+/wXEIEmD2c=";
  };

  nativeBuildInputs = [ makeWrapper ];

  makeFlags = [
    "DESTDIR=$(out)/bin"
    "MANDIR=$(out)/share/man"
  ];

  postPatch = ''
    substituteInPlace check_ssl_cert --replace-fail \
      /bin/cat \
      cat
  '';

  postInstall = ''
    wrapProgram $out/bin/check_ssl_cert \
      --prefix PATH : "${
        lib.makeBinPath (
          [
            bc
            bind.host
            bind.dnsutils # dig
            coreutils # date, timeout, cat
            curl
            file
            netcat-gnu
            nmap
            openssl
            python3
            which
            gnugrep
            gnused
            net-tools # hostname
            gawk
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
