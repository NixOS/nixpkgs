{ lib, stdenv, fetchFromGitHub, automake, cmake, autoconf, curl, numactl }:

stdenv.mkDerivation rec {
  pname = "grpc_cli";
<<<<<<< HEAD
  version = "1.58.0";
=======
  version = "1.54.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "grpc";
    repo = "grpc";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-JxkQZSmI3FSAoSd45uciCpsTeGuAvRhG/BGyC4NKOjo=";
=======
    hash = "sha256-svQxWHCoDHYZSvSrzUuwO0+6WMtgKsu+uVDV1mP/nL4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    fetchSubmodules = true;
  };
  nativeBuildInputs = [ automake cmake autoconf ];
  buildInputs = [ curl numactl ];
  cmakeFlags = [ "-DgRPC_BUILD_TESTS=ON" ];
  makeFlags = [ "grpc_cli" ];
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isAarch64 "-Wno-error=format-security";
  installPhase = ''
    runHook preInstall

    install -Dm555 grpc_cli "$out/bin/grpc_cli"

    runHook postInstall
  '';
  meta = with lib; {
    description = "The command line tool for interacting with grpc services.";
    homepage = "https://github.com/grpc/grpc";
    license = licenses.asl20;
    maintainers = with maintainers; [ doriath ];
    platforms = platforms.linux;
  };
}
