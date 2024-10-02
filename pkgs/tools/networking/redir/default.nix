{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "redir";
  version = "3.3";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "redir";
    rev = "v${version}";
    sha256 = "13n401i3q0xwpfgr21y47kgihi057wbh59xlsna8b8zpm973qny1";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "TCP port redirector for UNIX";
    homepage = "https://github.com/troglobit/redir";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "redir";
  };
}
