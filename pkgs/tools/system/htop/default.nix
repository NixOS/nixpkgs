{ lib, fetchFromGitHub, stdenv, autoreconfHook
, ncurses, IOKit, python3
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "htop";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "htop-dev";
    repo = pname;
    rev = version;
    sha256 = "096gdnpaszs5rfp7qj8npi2jkvdqpp8mznn89f97ykrg6pgagwq4";
  };

  patches = [
    # Never use glyphs for checkmarks. Issue - https://github.com/htop-dev/htop/issues/29
    # Remove with the next release.
    (fetchpatch {
      url = "https://github.com/htop-dev/htop/commit/96074058278829facb86f6f4de099d56a00a0c0e.patch";
      sha256 = "1rnfvjfsvfgr1s7kzr1hk6nwik6shcq4mg6dlbgdq0f2fz0cnazk";
    })
  ];

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
