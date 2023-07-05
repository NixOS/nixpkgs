{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, CoreServices
, SystemConfiguration
}:

rustPlatform.buildRustPackage {
  pname = "deploy-rs";
  version = "unstable-2023-06-04";

  src = fetchFromGitHub {
    owner = "serokell";
    repo = "deploy-rs";
    rev = "65211db63ba1199f09b4c9f27e5eba5ec50d76ac";
    hash = "sha256-1FldJ059so0X/rScdbIiOlQbjjSNCCTdj2cUr5pHU4A=";
  };

  cargoHash = "sha256-iUYtLH01YGxsDQbSnQrs4jw2eJxsOn2v3HOIfhsZbdQ=";

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
