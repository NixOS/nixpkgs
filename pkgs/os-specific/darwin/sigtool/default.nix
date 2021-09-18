{ lib, stdenv, fetchFromGitHub, pkg-config, cmake, makeWrapper, openssl }:

stdenv.mkDerivation {
  name = "sigtool";

  src = fetchFromGitHub {
    owner = "thefloweringash";
    repo = "sigtool";
    rev = "2a13539dc4893f39412a3fb810afc78b183df3df";
    sha256 = "sha256-iCsdklN3crFx6CKsMIUP/fA3twLh4ArQh7OsVug5UjE=";
  };

  nativeBuildInputs = [ pkg-config makeWrapper ];
  buildInputs = [ openssl ];

  installFlags = [ "PREFIX=$(out)" ];
}
