{ lib, stdenvNoCC, fetchFromGitHub, shellcheck, shellspec, busybox-sandbox-shell, ksh, mksh, yash, zsh }:

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

  nativeCheckInputs = [ shellcheck shellspec busybox-sandbox-shell ksh mksh yash zsh ];

  preCheck = ''
    sed -i '/shellspec -s posh/d' Makefile
  '';

  checkTarget = "check testall";

  meta = with lib; {
    description = "An elegant option/argument parser for shell scripts (full support for bash and all POSIX shells)";
    homepage = "https://github.com/ko1nksm/getoptions";
    license = licenses.cc0;
    platforms = platforms.all;
    maintainers = with maintainers; [ matrss ];
  };
}
