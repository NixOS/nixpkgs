{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "hayagriva";
  version = "0.5.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-oUIMtyQoOqn3C8XOSLFHso76GOHB54ZoLBSDWaDcqdE=";
  };

  cargoHash = "sha256-l1iFF44qTaBu2QDxkTLZTo+R32OTu5za1qdXtq43IM8=";

  buildFeatures = [ "cli" ];

  checkFlags = [
    # requires internet access
    "--skip=try_archive"
    "--skip=always_archive"

    # requires a separate large repository
    "--skip=csl::tests::test_csl"
  ];

  meta = with lib; {
    description = "Work with references: Literature database management, storage, and citation formatting";
    homepage = "https://github.com/typst/hayagriva";
    changelog = "https://github.com/typst/hayagriva/releases/tag/v${version}";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "hayagriva";
  };
}
