{ stdenv, lib, fetchFromGitHub, rustPlatform, CoreServices, SystemConfiguration }:

rustPlatform.buildRustPackage rec {
  pname = "deploy-rs-unstable";
  version = "2022-05-26";

  src = fetchFromGitHub {
    owner = "serokell";
    repo = "deploy-rs";
    rev = "184349d8149436748986d1bdba087e4149e9c160";
    sha256 = "sha256-kJ0ENmnQJ4qL2FeYKZba9kvv1KmIuB3NVpBwMeI7AJQ=";
  };

  cargoHash = "sha256-Ocb1kwNDfODGceCaCJ16CTGGTxIQacgHQ3I6HIR/EUo=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices SystemConfiguration ];

  meta = with lib; {
    description = " A simple multi-profile Nix-flake deploy tool. ";
    homepage = "https://github.com/serokell/deploy-rs";
    license = licenses.mpl20;
    maintainers = [ maintainers.teutat3s ];
  };
}
