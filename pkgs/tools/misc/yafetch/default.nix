{ lib, stdenv, fetchFromGitLab }:

stdenv.mkDerivation rec {
  pname = "yafetch";
  version = "unstable-2021-06-01";

  src = fetchFromGitLab {
    owner = "cyberkitty";
    repo = pname;
    rev = "d9bbc1e4abca87028f898473c9a265161af3c287";
    sha256 = "0hyb5k7drnm9li720z1fdvz7b15xgf7n6yajnz1j98day3k88bqk";
  };

  # Use the provided NixOS logo automatically
  prePatch = ''
    substituteInPlace ./config.h --replace \
      "#include \"ascii/tux.h\"" "#include \"ascii/nixos.h\""
  '';

  # Fixes installation path
  PREFIX = placeholder "out";

  meta = with lib; {
    homepage = "https://gitlab.com/cyberkitty/yafetch";
    description = "Yet another fetch clone written in C++";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.ivar ];
    platforms = platforms.linux;
  };
}
