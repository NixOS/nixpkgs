{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "textplots";
  version = "0.8.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-rYUo8A5jasGQb9CjW5u5kM7PIocq353R6v+Z7OhzVUg=";
  };

  cargoHash = "sha256-1Z+Og3n9/LUzfBoWNXjvNfuQByEq3vtXhGzi6X961w0=";

  meta = with lib; {
    description = "Terminal plotting written in Rust";
    homepage = "https://github.com/loony-bean/textplots-rs";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
