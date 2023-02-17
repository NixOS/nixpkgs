{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, CoreServices
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "deploy-rs";
  version = "unstable-2022-11-18";

  src = fetchFromGitHub {
    owner = "serokell";
    repo = "deploy-rs";
    rev = "2a3c5f70eee04a465aa534d8bd4fcc9bb3c4a8ce";
    hash = "sha256-0w6iD3GSSQbIeSFVDzAAQZB+hDq670ZTms3d9XI+BtM=";
  };

  cargoHash = "sha256-Ki9/mYNLUq74v3u+e3aM139+06CTrvPLJv0O+qHL9dA=";

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreServices
    SystemConfiguration
  ];

  meta = with lib; {
    description = "Multi-profile Nix-flake deploy tool";
    homepage = "https://github.com/serokell/deploy-rs";
    license = licenses.mpl20;
    maintainers = with maintainers; [ teutat3s ];
  };
}
