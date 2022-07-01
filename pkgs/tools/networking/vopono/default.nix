{ lib
, fetchCrate
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "vopono";
  version = "0.9.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-Z9eAbGq4ePbLyp6SWSbgLy4ogo2EFMps2HT8JUQFuR4=";
  };

  cargoHash = "sha256-aeukVOn6uBZlsPl35erJNlKxp929czuFCzllswYOWhM=";

  meta = with lib; {
    description = "Run applications through VPN connections in network namespaces";
    homepage = "https://github.com/jamesmcm/vopono";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
