{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deps";
  version = "1.4.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-WzvWkn2o39InESSzF5oLVP1I876b+r749hjZgh2DxOk=";
  };

  cargoSha256 = "15pf4x2aw8sl65g63cz4yv9y78yc2wi25h9khpqx6i7gyd7dxbsc";

  meta = with lib; {
    description = "Cargo subcommand for building dependency graphs of Rust projects";
    homepage = "https://github.com/m-cat/cargo-deps";
    license = licenses.mit;
    maintainers = with maintainers; [ arcnmx ];
  };
}
