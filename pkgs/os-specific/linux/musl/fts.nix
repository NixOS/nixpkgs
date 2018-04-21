{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig }:

stdenv.mkDerivation rec {
  name = "musl-fts-${version}";
  version = "2017-01-13";
  src = fetchFromGitHub {
    owner = "pullmoll";
    repo = "musl-fts";
    rev = "0bde52df588e8969879a2cae51c3a4774ec62472";
    sha256 = "1q8cpzisziysrs08b89wj0rm4p6dsyl177cclpfa0f7spjm3jg03";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  setupHook = ./fts-setup-hook.sh;
}
