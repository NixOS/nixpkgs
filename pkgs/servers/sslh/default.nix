{ lib, stdenv, fetchFromGitHub, fetchpatch, libcap, libev, libconfig, perl, tcp_wrappers, pcre2, nixosTests }:

stdenv.mkDerivation rec {
  pname = "sslh";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "yrutschle";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-KXjoYtiGaOrdWRbI0umNfxbtS7p+YaW352lC/5f+AM4=";
  };

  postPatch = "patchShebangs *.sh";

  buildInputs = [ libcap libev libconfig perl tcp_wrappers pcre2 ];

  makeFlags = [ "USELIBCAP=1" "USELIBWRAP=1" ];

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
