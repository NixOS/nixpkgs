{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "steamguard-cli";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "dyc3";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-i+q8hiElLuA1oHRLASiO/icEmhd1VqvV/zKGV0CSXms=";
  };

  cargoHash = "sha256-1K482GygV9SLpbpwF1iI3pwL0gcNo0eM2goKTgscK64=";

  meta = with lib; {
    changelog = "https://github.com/dyc3/steamguard-cli/releases/tag/v${version}";
    description = "A linux utility for generating 2FA codes for Steam and managing Steam trade confirmations.";
    homepage = "https://github.com/dyc3/steamguard-cli";
    license = with licenses; [ gpl3Only ];
    mainProgram = "steamguard";
    maintainers = with maintainers; [ surfaceflinger ];
    platforms = platforms.linux;
  };
}
