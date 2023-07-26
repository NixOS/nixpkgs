{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "textplots";
  version = "0.8.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-NBUp5kFiODqoJrg/JBPhtaVsOikppqt2jbd3C3RQ7qg=";
  };

  cargoHash = "sha256-hHj3Da399gbRbgHgHcBE53HJusWoPbRA184tcCSJ4fc=";

  meta = with lib; {
    description = "Terminal plotting written in Rust";
    homepage = "https://github.com/loony-bean/textplots-rs";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
