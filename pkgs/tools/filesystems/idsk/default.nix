{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {

  pname = "idsk";
  version = "0.20";

  src = fetchFromGitHub {
    repo = "idsk";
    owner = "cpcsdk";
    rev = "v${version}";
    sha256 = "05zbdkb9s6sfkni6k927795w2fqdhnf3i7kgl27715sdmmdab05d";
  };

  nativeBuildInputs = [ cmake ];

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.cc.isGNU [
    # Needed with GCC 12 but breaks on darwin (with clang)
    "-std=c++14"
  ]);

  installPhase = ''
    mkdir -p $out/bin
    cp iDSK $out/bin
  '';

  meta = with lib; {
    description = "Manipulating CPC dsk images and files";
    homepage = "https://github.com/cpcsdk/idsk" ;
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "iDSK";
    platforms = platforms.all;
  };
}
