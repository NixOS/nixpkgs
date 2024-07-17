{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "hayagriva";
  version = "0.5.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-6LJRvyCgcj/m25kC26vT3aUREstXmmCIR4+LoHZgIqw=";
  };

  cargoHash = "sha256-asINO3zy4x+n7chriC8ESCe3K027xFUNi+54XtQwS0w=";

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
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "hayagriva";
  };
}
