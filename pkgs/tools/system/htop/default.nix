{ lib, fetchFromGitHub, stdenv, autoreconfHook
, ncurses, IOKit
}:

stdenv.mkDerivation rec {
  pname = "htop";
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "htop-dev";
    repo = pname;
    rev = version;
    sha256 = "1fckfv96vzqjs3lzy0cgwsqv5vh1sxca3fhvgskmnkvr5bq6cia9";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ ncurses
  ] ++ lib.optionals stdenv.isDarwin [ IOKit ];

  meta = with stdenv.lib; {
    description = "An interactive process viewer for Linux";
    homepage = "https://htop.dev";
    license = licenses.gpl2Only;
    platforms = with platforms; linux ++ freebsd ++ openbsd ++ darwin;
    maintainers = with maintainers; [ rob relrod ];
  };
}
