{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "grass";
  version = "0.12.4";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-tp3L8TDIG/92RupRAyRWSiALqE1XBK8jespKcSdSzsM=";
  };

  cargoHash = "sha256-hxVcHD5k1YwXCOq1UdiivPLwtY2egGvf/T3NrZTAB/k=";

  # tests require rust nightly
  doCheck = false;

  meta = with lib; {
    description = "A Sass compiler written purely in Rust";
    homepage = "https://github.com/connorskees/grass";
    changelog = "https://github.com/connorskees/grass/blob/master/CHANGELOG.md#${replaceStrings [ "." ] [ "" ] version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
