{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "hunt";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "LyonSyonII";
    repo = "hunt-rs";
    rev = "v${version}";
    sha256 = "sha256-cQA7LB3gDvANCuUDyXjvSE5pEljJRE/YwajR8deAP2E=";
  };

  cargoHash = "sha256-WCECfyQLHDlXWqi0dNRJSTkg8srZf3FCqV2EgV3X0Uc=";

  meta = with lib; {
    description = "Simplified Find command made with Rust";
    homepage = "https://github.com/LyonSyonII/hunt";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "hunt";
  };
}
