{ lib, stdenv, fetchFromGitHub, libcap, libev, libconfig, perl, tcp_wrappers, pcre2, nixosTests }:

stdenv.mkDerivation rec {
  pname = "sslh";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "yrutschle";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-NCjLqYSPHukY11URQ/n+33Atzl4DhPDbNOEDaP6bQlg=";
  };

  postPatch = "patchShebangs *.sh";

  buildInputs = [ libev libconfig perl pcre2 ] ++ lib.optionals stdenv.isLinux [ libcap tcp_wrappers ];

  makeFlags = lib.optionals stdenv.isLinux [ "USELIBCAP=1" "USELIBWRAP=1" ];

  postInstall = ''
    # install all flavours
    install -p sslh-fork "$out/sbin/sslh-fork"
    install -p sslh-select "$out/sbin/sslh-select"
    install -p sslh-ev "$out/sbin/sslh-ev"
    ln -sf sslh-fork "$out/sbin/sslh"
  '';

  installFlags = [ "PREFIX=$(out)" ];

  hardeningDisable = [ "format" ];

  passthru.tests = {
    inherit (nixosTests) sslh;
  };

  meta = with lib; {
    description = "Applicative Protocol Multiplexer (e.g. share SSH and HTTPS on the same port)";
    license = licenses.gpl2Plus;
    homepage = "https://www.rutschle.net/tech/sslh/README.html";
    maintainers = with maintainers; [ koral fpletz ];
    platforms = platforms.all;
  };
}
