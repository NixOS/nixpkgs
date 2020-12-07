{ lib, fetchFromGitHub, stdenv, autoreconfHook
, ncurses, IOKit
}:

stdenv.mkDerivation rec {
  pname = "htop";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "htop-dev";
    repo = pname;
    rev = version;
    sha256 = "0ylig6g2w4r3qfb16cf922iriqyn64frkzpk87vpga16kclvf08y";
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
