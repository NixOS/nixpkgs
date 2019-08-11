{ stdenv, fetchFromGitHub, autoreconfHook, autoconf-archive
, pkgconfig, gettext, libssl }:

stdenv.mkDerivation rec {
  pname = "axel";
  version = "2.17.3";

  src = fetchFromGitHub {
    owner = "axel-download-accelerator";
    repo = pname;
    rev = "v${version}";
    sha256 = "0kdd2y92plv240ba2j3xrm0f8xygvm1ijghnric4whsnxvmgym7h";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig autoconf-archive ];

  buildInputs = [ gettext libssl ];

  installFlags = [ "ETCDIR=$(out)/etc" ];

  meta = with stdenv.lib; {
    description = "Console downloading program with some features for parallel connections for faster downloading";
    homepage = "https://github.com/axel-download-accelerator/axel";
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; linux;
    license = licenses.gpl2;
  };
}
