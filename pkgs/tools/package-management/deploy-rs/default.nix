{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, CoreServices
, SystemConfiguration
}:

rustPlatform.buildRustPackage {
  pname = "deploy-rs";
  version = "unstable-2023-09-12";

  src = fetchFromGitHub {
    owner = "serokell";
    repo = "deploy-rs";
    rev = "31c32fb2959103a796e07bbe47e0a5e287c343a8";
    hash = "sha256-wE5kHco3+FQjc+MwTPwLVqYz4hM7uno2CgXDXUFMCpc=";
  };

  cargoHash = "sha256-WqZnDWMrqWy1rzR6n+acFW6VHWbDnQmoxtPDA5B37JU=";

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
