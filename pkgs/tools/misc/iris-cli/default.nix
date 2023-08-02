{
  lib
, fetchFromGitHub
, stdenv
, lexbor
, curl
, pkg-config
}:

stdenv.mkDerivation (finalAttrs: rec {
  pname = "iris-cli";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "iris-cli";
    repo = "iris";
    rev = "v${version}";
    hash = "sha256-GUFDWZrtauN1pEWmnDUnUPwEEw0Pp2qKFrsFX0Ou9/E=";
  };

  buildInputs = [ lexbor curl pkg-config ];

  preBuild = ''
    ls
    mkdir bin
  '';

  buildPhase = ''
    make modules
    make build
  '';

  installPhase = ''
    DESTDIR=$out make install
  '';

  meta = with lib; {
    homepage = "https://github.com/iris-cli/iris";
    description = "An eater & feeder of information";
    license = licenses.asl20;
    maintainers = with maintainers; [ cafkafk ];
    platforms = platforms.linux;
  };
})
