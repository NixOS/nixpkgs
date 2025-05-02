{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "hayagriva";
  version = "0.5.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-hE0Oi+0vDQGDEOYtHiPit1RrrkrlLZs20nEHOm/bp5M=";
  };

  cargoHash = "sha256-WZbbjLDHYJTiuM0Lh9YfVvLTvK/jfO8fRbLqZ8XOLGg=";

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
