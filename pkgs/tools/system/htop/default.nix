{ lib, fetchFromGitHub, stdenv, autoreconfHook
, ncurses, IOKit
}:

stdenv.mkDerivation rec {
  pname = "htop";
  version = "3.0.5";

  src = fetchFromGitHub {
    owner = "htop-dev";
    repo = pname;
    rev = version;
    sha256 = "sha256-9zecDd3oZ24RyOLnKdJmR29Chx6S24Kvuf/F7RYzl4I=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ ncurses
  ] ++ lib.optionals stdenv.isDarwin [ IOKit ];

  meta = with lib; {
    description = "An interactive process viewer for Linux";
    homepage = "https://htop.dev";
    license = licenses.gpl2Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ rob relrod ];
    changelog = "https://github.com/htop-dev/${pname}/blob/${version}/ChangeLog";
  };
}
