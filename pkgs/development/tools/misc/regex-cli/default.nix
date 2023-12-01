{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "regex-cli";
  version = "0.2.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Uo1y3L4l/Ik//NoBLsCqvQmC7ZGaSt0XzT1wDGCoU4U=";
  };

  cargoHash = "sha256-O0KAY9XeP+LFcvAwO5SbF5yMHU1KZ77UdkAGAcx1hHc=";

  meta = with lib; {
    description = "A command line tool for debugging, ad hoc benchmarking and generating regular expressions";
    homepage = "https://github.com/rust-lang/regex/tree/master/regex-cli";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
