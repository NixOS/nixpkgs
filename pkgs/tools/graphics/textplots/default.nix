{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "textplots";
  version = "0.8.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-fzuvJwxU6Vi9hWW0IcRAHUeSoOBpGyebzvgjKiYxAbs=";
  };

  cargoHash = "sha256-QH27BjS75jZOQBBflGapAjg49LpG12DxWZo8TjLoXmI=";

  meta = with lib; {
    description = "Terminal plotting written in Rust";
    homepage = "https://github.com/loony-bean/textplots-rs";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
