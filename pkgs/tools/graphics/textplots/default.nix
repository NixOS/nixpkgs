{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "textplots";
  version = "0.8.5";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-83EAe6O8ETsuGJ5MK6kt68OnJL+r+BAYkFzvzlxHyp4=";
  };

  cargoHash = "sha256-O47b00PGRXTWWxywitS2V15gXahzgjNvFKUvE+VMXaM=";

  buildFeatures = [ "tool" ];

  meta = with lib; {
    description = "Terminal plotting written in Rust";
    homepage = "https://github.com/loony-bean/textplots-rs";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "textplots";
  };
}
