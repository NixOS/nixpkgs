{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, CoreServices
, SystemConfiguration
}:

rustPlatform.buildRustPackage {
  pname = "deploy-rs";
  version = "unstable-2023-01-19";

  src = fetchFromGitHub {
    owner = "serokell";
    repo = "deploy-rs";
    rev = "8c9ea9605eed20528bf60fae35a2b613b901fd77";
    hash = "sha256-QO1xF7stu5ZMDLbHN30LFolMAwY6TVlzYvQoUs1RD68=";
  };

  cargoHash = "sha256-UKiG2Muw3cT17TCl0pZQGfzVdN5tajSZ1ULyGRaZ9tQ=";

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
