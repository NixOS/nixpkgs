{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "regex-cli";
  version = "0.1.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-4l12Eaab1G3SP3Srxt3UR9MCRlLm0KDPx/Z2rQpSQR0=";
  };

  cargoHash = "sha256-fAIYWzfzq/VuBc684SG7p365uudX9M/TtVdMahyrmdk=";

  meta = with lib; {
    description = "A command line tool for debugging, ad hoc benchmarking and generating regular expressions";
    homepage = "https://github.com/rust-lang/regex/tree/master/regex-cli";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
