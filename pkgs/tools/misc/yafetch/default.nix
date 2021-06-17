{ lib, stdenv, fetchFromGitLab }:

stdenv.mkDerivation rec {
  pname = "yafetch";
  version = "unstable-2021-06-15";

  src = fetchFromGitLab {
    owner = "cyberkitty";
    repo = pname;
    rev = "423a7d1f1ef8f0e4caf586710828620d3cb593e3";
    sha256 = "184yy7i8ca2fh6d1rxyhxi9gqb57fpz7ia0i56dl1zhg769m8b99";
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
    maintainers = with maintainers; [ ivar ashley ];
    platforms = platforms.linux;
  };
}
