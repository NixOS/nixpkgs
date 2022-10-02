{ lib, stdenv, fetchFromGitHub, fetchpatch, ncurses, pkg-config }:

stdenv.mkDerivation rec {
  pname = "2048-in-terminal";
  version = "unstable-2021-09-12";

  src = fetchFromGitHub {
    sha256 = "1jgacyimn59kxqhrk8jp13qayc2mncxhx393spqcxbz0sj6lxq9p";
    rev = "466abe827638598e40cb627d2b017fe8f76b3a14";
    repo = "2048-in-terminal";
    owner = "alewmoose";
  };

  # Fix pending upstream inclusion for ncurses-6.3 support:
  #  https://github.com/alewmoose/2048-in-terminal/pull/6
  patches = [
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://github.com/alewmoose/2048-in-terminal/commit/b1c78dc4b3cca3a193b1afea1ab85a75966823cf.patch";
      sha256 = "05ibpgr83r7zxsak2l0gaf33858bp0sp0mjfdpmcmw745z3jw7q1";
    })
  ];

  buildInputs = [ ncurses ];
  nativeBuildInputs = [ pkg-config ];

  enableParallelBuilding = true;

  preInstall = ''
    mkdir -p $out/bin
  '';
  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Animated console version of the 2048 game";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
