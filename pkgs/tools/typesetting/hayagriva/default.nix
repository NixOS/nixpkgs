{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "hayagriva";
  version = "0.4.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-d4T+GF0bdMjpjwcN56yYpEw4aZCvJ19P1cbPuVhFR0A=";
  };

  cargoHash = "sha256-mRKvCnW4XVXYzOKQ5rASwiwpLdqpEgGlq8W4gB7hHco=";

  buildFeatures = [ "cli" ];

  checkFlags = [
    # requires internet access
    "--skip=try_archive"

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
