{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "hayagriva";
  version = "0.3.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-4HX0X8HDn0/D9mcruCVKeIs9ryCxYagW5eJ/DSqtprY=";
  };

  cargoHash = "sha256-JvRWdoZ5/jG09ex7avkE3JUcdMGIsfirSx9PDyAtVfU=";

  buildFeatures = [ "cli" ];

  meta = with lib; {
    description = "Work with references: Literature database management, storage, and citation formatting";
    homepage = "https://github.com/typst/hayagriva";
    changelog = "https://github.com/typst/hayagriva/releases/tag/v${version}";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
