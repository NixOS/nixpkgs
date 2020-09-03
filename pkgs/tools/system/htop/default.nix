{ lib, fetchFromGitHub, stdenv, autoreconfHook
, ncurses, IOKit, python3
}:

stdenv.mkDerivation rec {
  pname = "htop";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "htop-dev";
    repo = pname;
    rev = version;
    sha256 = "0kjlphdvwwbj91kk91s4ksc954d3c2bznddzx2223jmb1bn9rcsa";
  };

  nativeBuildInputs = [ autoreconfHook python3 ];

  buildInputs = [ ncurses
  ] ++ lib.optionals stdenv.isDarwin [ IOKit ];

  meta = with stdenv.lib; {
    description = "An interactive process viewer for Linux";
    homepage = "https://hisham.hm/htop/";
    license = licenses.gpl2Plus;
    platforms = with platforms; linux ++ freebsd ++ openbsd ++ darwin;
    maintainers = with maintainers; [ rob relrod ];
  };
}
