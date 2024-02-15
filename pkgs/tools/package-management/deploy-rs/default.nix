{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, CoreServices
, SystemConfiguration
}:

rustPlatform.buildRustPackage {
  pname = "deploy-rs";
  version = "unstable-2023-12-20";

  src = fetchFromGitHub {
    owner = "serokell";
    repo = "deploy-rs";
    rev = "b709d63debafce9f5645a5ba550c9e0983b3d1f7";
    hash = "sha256-0VUbWBW8VyiDRuimMuLsEO4elGuUw/nc2WDeuO1eN1M=";
  };

  cargoHash = "sha256-PVeCB1g3JSYE6PKWHyE3hfN/CKlb9XErt8uaD/ZyxIs=";

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreServices
    SystemConfiguration
  ];

  meta = with lib; {
    description = "Multi-profile Nix-flake deploy tool";
    homepage = "https://github.com/serokell/deploy-rs";
    license = licenses.mpl20;
    maintainers = with maintainers; [ teutat3s ];
    mainProgram = "deploy";
  };
}
