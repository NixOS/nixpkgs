{ lib, stdenv, fetchFromGitLab }:

stdenv.mkDerivation rec {
  pname = "yafetch";
  version = "unstable-2021-07-18";

  src = fetchFromGitLab {
    owner = "cyberkitty";
    repo = pname;
    rev = "f3efbca54df1ffea22cc40034114af141ccff9c1";
    sha256 = "1cxhrjy9vzq87rzql4dcknkwca7nydysp1p1x4fh1qfw79dfdmxw";
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
