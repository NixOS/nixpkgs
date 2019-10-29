{
    cargo
  , makeRustPlatform
  , fetchFromGitHub
  , lib
  , ...
}:

let
  rustPlatform = makeRustPlatform {
    rustc = cargo;
    cargo = cargo;
  };
in
  rustPlatform.buildRustPackage rec {
    name = "onefetch-${version}";
    version = "1.7.0";
    
    src = fetchFromGitHub {
      owner = "o2sh";
      repo = "onefetch";
      rev = version;
      sha256 = "1p16mg4ak9ppx3y11l3r4y6356drwhnmrlxsaqx01n53ii5ij9kg";
    };
    cargoSha256 = "0cpfjxn6nqsrnmgvjzr17n6xbbyfl9c91d5kbrmxb6jyig98k6aq";
    buildInputs = [ ];
    CARGO_HOME = "$(mktemp -d cargo-home.XXX)";

    meta = with lib; {
      homepage = https://github.com/o2sh/onefetch;
      description = ''Displays information about your Git project directly on your terminal'';
      license = licenses.mit;
      maintainers = with maintainers; [ kloenk ];
    };
  }
