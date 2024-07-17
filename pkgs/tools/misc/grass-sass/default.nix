{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "grass";
  version = "0.13.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-JFfNj+IMwIZ+DkaCy3mobSAaq4YphhMpGkx/P33UdJE=";
  };

  cargoHash = "sha256-WzG+yOjxTX2ms2JMpZJYcaKZw0gc9g6/OUe/T7oyK20=";

  # tests require rust nightly
  doCheck = false;

  meta = with lib; {
    description = "A Sass compiler written purely in Rust";
    homepage = "https://github.com/connorskees/grass";
    changelog = "https://github.com/connorskees/grass/blob/master/CHANGELOG.md#${
      replaceStrings [ "." ] [ "" ] version
    }";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "grass";
  };
}
