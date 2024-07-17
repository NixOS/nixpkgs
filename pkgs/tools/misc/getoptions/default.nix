{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  shellspec,
  busybox-sandbox-shell,
  ksh,
  mksh,
  yash,
  zsh,
}:

stdenvNoCC.mkDerivation rec {
  pname = "getoptions";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "ko1nksm";
    repo = "getoptions";
    rev = "v${version}";
    hash = "sha256-kUQ0dPjPr/A/btgFQu13ZLklnI284Ij74hCYbGgzF3A=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  doCheck = true;

  nativeCheckInputs = [
    shellspec
    ksh
    mksh
    yash
    zsh
  ] ++ lib.lists.optional (!stdenvNoCC.isDarwin) busybox-sandbox-shell;

  # Disable checks against yash, since shellspec seems to be broken for yash>=2.54
  # (see: https://github.com/NixOS/nixpkgs/pull/218264#pullrequestreview-1434402054)
  preCheck =
    ''
      sed -i '/shellspec -s posh/d' Makefile
      sed -i '/shellspec -s yash/d' Makefile
    ''
    + lib.strings.optionalString stdenvNoCC.isDarwin ''
      sed -i "/shellspec -s 'busybox ash'/d" Makefile
    '';

  checkTarget = "testall";

  meta = with lib; {
    description = "An elegant option/argument parser for shell scripts (full support for bash and all POSIX shells)";
    homepage = "https://github.com/ko1nksm/getoptions";
    license = licenses.cc0;
    platforms = platforms.all;
    maintainers = with maintainers; [ matrss ];
  };
}
