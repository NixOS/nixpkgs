{ lib, stdenv, fetchFromGitHub, cmake, sfml }:

stdenv.mkDerivation rec {
  pname = "antsimulator";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "johnBuffer";
    repo = "AntSimulator";
    rev = "v${version}";
    sha256 = "sha256-1KWoGbdjF8VI4th/ZjAzASgsLEuS3xiwObulzxQAppA=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ sfml ];

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 ./AntSimulator $out/bin/antsimulator
  '';

  meta = with lib; {
    homepage = "https://github.com/johnBuffer/AntSimulator";
    description = "Simple Ants simulator";
    license = licenses.free;
    maintainers = with maintainers; [ ivar ];
    platforms = platforms.unix;
  };
}
