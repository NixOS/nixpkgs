{ lib, stdenv, fetchFromGitHub, libcap, libconfig, perl, tcp_wrappers, pcre2, nixosTests }:

stdenv.mkDerivation rec {
  pname = "sslh";
  version = "1.22c";

  src = fetchFromGitHub {
    owner = "yrutschle";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-A+nUWiOPoz/T5afZUzt5In01e049TgHisTF8P5Vj180=";
  };

  postPatch = "patchShebangs *.sh";

  buildInputs = [ libcap libconfig perl tcp_wrappers pcre2 ];

  makeFlags = [ "USELIBCAP=1" "USELIBWRAP=1" ];

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
