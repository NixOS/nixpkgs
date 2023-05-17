{ lib, stdenv, fetchFromGitHub, pkg-config, ncurses, which }:

stdenv.mkDerivation rec {
  pname = "progress";
  version = "0.16";

  src = fetchFromGitHub {
    owner = "Xfennec";
    repo = "progress";
    rev = "v${version}";
    sha256 = "sha256-kkEyflyBaQ5hUVo646NUuC1u54uzLJJsVFej9pMEwT0=";
  };

  nativeBuildInputs = [ pkg-config which ];
  buildInputs = [ ncurses ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/Xfennec/progress";
    description = "Tool that shows the progress of coreutils programs";
    license = licenses.gpl3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ pSub ];
  };
}
