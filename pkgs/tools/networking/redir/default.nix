{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "redir-${version}";
  version = "3.3";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "redir";
    rev = "v${version}";
    sha256 = "13n401i3q0xwpfgr21y47kgihi057wbh59xlsna8b8zpm973qny1";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "A TCP port redirector for UNIX";
    homepage = https://github.com/troglobit/redir;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ globin ];
    platforms = stdenv.lib.platforms.linux;
  };
}
