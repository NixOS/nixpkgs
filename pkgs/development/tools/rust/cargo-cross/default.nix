{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-cross";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "cross-rs";
    repo = "cross";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-TFPIQno30Vm5m2nZ2b3d0WPu/98UqANLhw3IZiE5a38=";
  };

  cargoHash = "sha256-x+DrKo79R8TAeLVuvIIguQs3gdAHiAQ9dUU2/eZRZ0c=";

  checkFlags = [
    "--skip=docker::shared::tests::directories::test_host"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Zero setup cross compilation and cross testing";
    homepage = "https://github.com/cross-rs/cross";
    changelog = "https://github.com/cross-rs/cross/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ otavio ];
    mainProgram = "cross";
  };
}
