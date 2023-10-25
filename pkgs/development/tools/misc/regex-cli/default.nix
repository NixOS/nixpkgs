{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "regex-cli";
  version = "0.1.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-i+3HluKbR+5e2Nd0E0Xy+mwsC9x3+21rFdCNmII8HsM=";
  };

  cargoHash = "sha256-u6Gaeo9XDcyxZwBt67IF1X7rr4vR9jIrzr8keHGU88w=";

  meta = with lib; {
    description = "A command line tool for debugging, ad hoc benchmarking and generating regular expressions";
    homepage = "https://github.com/rust-lang/regex/tree/master/regex-cli";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
