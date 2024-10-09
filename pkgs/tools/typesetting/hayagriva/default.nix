{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "hayagriva";
  version = "0.6.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-ic1ohp0zmiFgfNSfI6XRL/3CJ2p+afW4IAEz2l4CL8Q=";
  };

  cargoHash = "sha256-G3rBvFzlp3Dg/k6BILNH6xNX+i9mEv9muZOiGkcad38=";

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
