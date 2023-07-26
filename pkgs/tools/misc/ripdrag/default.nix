{ lib, rustPlatform, fetchCrate, pkg-config, wrapGAppsHook4, gtk4 }:

rustPlatform.buildRustPackage rec {
  pname = "ripdrag";
  version = "0.3.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-SSH/HCvrUvWNIqlx7F6eNMM1eGxGGg5eel/X/q1Um1g=";
  };

  cargoHash = "sha256-FvStPBmyETjCaBqQK/KYHpwtqNCiY6n484E5bumdRzk=";

  nativeBuildInputs = [ pkg-config wrapGAppsHook4 ];

  buildInputs = [ gtk4 ];

  meta = with lib; {
    description = "An application that lets you drag and drop files from and to the terminal";
    homepage = "https://github.com/nik012003/ripdrag";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
  };
}
