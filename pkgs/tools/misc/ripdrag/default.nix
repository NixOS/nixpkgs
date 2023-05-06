{ lib, rustPlatform, fetchCrate, pkg-config, gtk4 }:

rustPlatform.buildRustPackage rec {
  pname = "ripdrag";
  version = "0.3.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-D4WB1RdMPJfSLbJ96h3OuFhokfyY8Gamctm0XY694YM=";
  };

  cargoSha256 = "sha256-C2I26E/dd18A4DDgOYGR8aS1RBrrNUwaXI4ZJHcrKy0=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gtk4 ];

  meta = with lib; {
    description = "An application that lets you drag and drop files from and to the terminal";
    homepage = "https://github.com/nik012003/ripdrag";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
  };
}
