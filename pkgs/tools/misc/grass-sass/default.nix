{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "grass";
  version = "0.13.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-catGfGiKjB6KZCt6yjwdR5VV0RAaBfiUnjlyCCBguBs=";
  };

  cargoHash = "sha256-xonfDCJWVIuZQOBSLcrEFnziHwz6ZNQQxvVh+ulueUo=";

  # tests require rust nightly
  doCheck = false;

  meta = with lib; {
    description = "Sass compiler written purely in Rust";
    homepage = "https://github.com/connorskees/grass";
    changelog = "https://github.com/connorskees/grass/blob/master/CHANGELOG.md#${replaceStrings [ "." ] [ "" ] version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "grass";
  };
}
