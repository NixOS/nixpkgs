{ lib, rustPlatform, fetchCrate, pkg-config, gtk4 }:

rustPlatform.buildRustPackage rec {
  pname = "ripdrag";
  version = "0.2.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-bXyJcSJfKHkcwTayEbX9sZZEBeP9qoH36QqBIDnmKQM=";
  };

  cargoSha256 = "sha256-PqoIJ0mbpaE4UX+kz3pFiqmTS1Vp+jF2OT5+3K2A0MQ=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gtk4 ];

  meta = with lib; {
    description = "An application that lets you drag and drop files from and to the terminal";
    homepage = "https://github.com/nik012003/ripdrag";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
  };
}
