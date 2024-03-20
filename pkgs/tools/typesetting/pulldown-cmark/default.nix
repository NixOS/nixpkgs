{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "pulldown-cmark";
  version = "0.10.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-7ZO3MdQBNgltrd4Anu19g0Gkye6Bc2WHDuSng6mB9pM=";
  };

  cargoHash = "sha256-4UUdsS3dK5a6phwYZqjNwX52UMLLe/LHxOiBanTRMZM=";

  meta = {
    description = "A pull parser for CommonMark written in Rust";
    homepage = "https://github.com/raphlinus/pulldown-cmark";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ CobaltCause ];
    mainProgram = "pulldown-cmark";
  };
}
