{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "textplots";
  version = "0.8.4";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-DtDxD3b8idYOBcHKkLbOy6NUU0bjWzDySGoW8uOT4xc=";
  };

  cargoHash = "sha256-tXqonC4qawS6eu9dPt/6/TVYCjTroG+9XikmYQHCLdA=";

  buildFeatures = [ "tool" ];

  meta = with lib; {
    description = "Terminal plotting written in Rust";
    homepage = "https://github.com/loony-bean/textplots-rs";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
