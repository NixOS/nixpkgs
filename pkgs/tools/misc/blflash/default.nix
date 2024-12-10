{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "blflash";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "spacemeowx2";
    repo = "blflash";
    rev = "v${version}";
    hash = "sha256-lv5bUbq5AnZVeR8V0A4pamY9ZIQAhLmvZEr+CRMPcj0=";
  };

  cargoHash = "sha256-NRBW2rGrtEmmxONTpCM1D+o5HtnLjp175Sq9+aCp7ZE=";

  meta = with lib; {
    description = "An bl602 serial flasher written in Rust";
    homepage = "https://github.com/spacemeowx2/blflash";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [ _0x4A6F ];
    mainProgram = "blflash";
  };
}
