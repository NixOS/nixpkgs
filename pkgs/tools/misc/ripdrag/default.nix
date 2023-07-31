{ lib, rustPlatform, fetchCrate, pkg-config, wrapGAppsHook4, gtk4 }:

rustPlatform.buildRustPackage rec {
  pname = "ripdrag";
  version = "0.3.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-vxAAAFLTIfLqYD7E/nwsHgFLhzMRF7DspIaWqAMZcXk=";
  };

  cargoHash = "sha256-6GKLBnG1p6iaFvnEQgfNlGpZwEG93tI256DCMLuJjOU=";

  nativeBuildInputs = [ pkg-config wrapGAppsHook4 ];

  buildInputs = [ gtk4 ];

  meta = with lib; {
    description = "An application that lets you drag and drop files from and to the terminal";
    homepage = "https://github.com/nik012003/ripdrag";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
  };
}
