{ lib, fetchFromGitHub, stdenv, autoreconfHook, ncurses,
IOKit, python3 }:

stdenv.mkDerivation rec {
  pname = "htop";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "htop-dev";
    repo = pname;
    rev = version;
    sha256 = "096gdnpaszs5rfp7qj8npi2jkvdqpp8mznn89f97ykrg6pgagwq4";
  };

  nativeBuildInputs = [ autoreconfHook python3 ];
  buildInputs =
    [ ncurses ] ++
    lib.optionals stdenv.isDarwin [ IOKit ];

  meta = with stdenv.lib; {
    description = "An interactive process viewer for Linux";
    homepage = "https://hisham.hm/htop/";
    license = licenses.gpl2Plus;
    platforms = with platforms; linux ++ freebsd ++ openbsd ++ darwin;
    maintainers = with maintainers; [ rob relrod ];
  };
}
