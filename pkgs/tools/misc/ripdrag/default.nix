{ lib, rustPlatform, fetchCrate, pkg-config, gtk4 }:

rustPlatform.buildRustPackage rec {
  pname = "ripdrag";
  version = "0.1.5";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-Pa/QYxdPt95deEjSXEVhm2jR3r8rTaKQj2DltT7EVAw=";
  };

  cargoSha256 = "sha256-jI7nF8Q8sA4AxkXvQ43r5GqcbTWffuf453DLGUs7I98=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gtk4 ];

  meta = with lib; {
    description = "An application that lets you drag and drop files from and to the terminal";
    homepage = "https://github.com/nik012003/ripdrag";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
  };
}
