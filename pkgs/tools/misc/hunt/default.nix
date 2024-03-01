{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "hunt";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "LyonSyonII";
    repo = "hunt-rs";
    rev = "v${version}";
    sha256 = "sha256-noqsxgx2FuSp3ekaaopLUPhq4YYBwM8uf4DzML5xLAE=";
  };

  cargoHash = "sha256-JErhe2Hu2Qpb5QoEurdy/WSShjkiV/Fai4/lVkisrEQ=";

  meta = with lib; {
    description = "Simplified Find command made with Rust";
    homepage = "https://github.com/LyonSyonII/hunt";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "hunt";
  };
}
