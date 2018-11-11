{ stdenv, fetchFromGitHub, cmake, gettext, ... }:

stdenv.mkDerivation rec {
  name = "musl-locales-${version}";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "rilian-la-te";
    repo = "musl-locales";
    rev = "682c6353a7d24063be78787d45e63bfcaca78582";
    sha256 = "07p5k16c10gwrz7gr74m6ylgax415r8r8xymp7bzhzydx2f3f0y4";
  };

  nativeBuildInputs = [ cmake gettext ];
}