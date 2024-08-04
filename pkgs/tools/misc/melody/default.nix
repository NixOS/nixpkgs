{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "melody";
  version = "0.19.0";

  src = fetchCrate {
    pname = "melody_cli";
    inherit version;
    hash = "sha256-sJVZ4dRP6mAx9g7iqwI3L2cMa5x4qQuzKWPXvOOq6q8=";
  };

  cargoHash = "sha256-8UWz+gYUxf2UNWZCnhQlGiSX6kPsHPlYcdl7wD3Rchs=";

  meta = with lib; {
    description = "Language that compiles to regular expressions";
    homepage = "https://github.com/yoav-lavi/melody";
    license = licenses.mit;
    maintainers = with maintainers; [ joelkoen ];
    mainProgram = "melody";
  };
}
