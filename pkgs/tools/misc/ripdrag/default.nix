{ lib, rustPlatform, fetchCrate, pkg-config, wrapGAppsHook4, gtk4 }:

rustPlatform.buildRustPackage rec {
  pname = "ripdrag";
  version = "0.4.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-9VGvwMovJb1IIpwf+1FxcxnPcmPl+59jfQC6365E95s=";
  };

  cargoHash = "sha256-kxT0wJodPiHXX/bsvrlPbyfUbxPBgmv68a8I5pKOwEg=";

  nativeBuildInputs = [ pkg-config wrapGAppsHook4 ];

  buildInputs = [ gtk4 ];

  meta = with lib; {
    description = "An application that lets you drag and drop files from and to the terminal";
    homepage = "https://github.com/nik012003/ripdrag";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
  };
}
