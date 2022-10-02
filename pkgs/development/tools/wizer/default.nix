{ lib, stdenv, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "wizer";
  version = "1.4.0";

  src = fetchCrate {
    inherit pname version;

    sha256 = "sha256-3Hc3KKqtbZtvD+3lb/W7+AyrwPukJyxpUe94KGQlzBI=";
  };

  cargoSha256 = "sha256-zv36/W7dNpIupYn8TS+NaF7uX+BVjrI6AW6Hrlqr8Xg=";

  cargoBuildFlags = [ "--bin" pname ];

  buildFeatures = [ "env_logger" "structopt" ];

  # Setting $HOME to a temporary directory is necessary to prevent checks from failing, as
  # the test suite creates a cache directory at $HOME/Library/Caches/BytecodeAlliance.wasmtime.
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "The WebAssembly pre-initializer";
    homepage = "https://github.com/bytecodealliance/wizer";
    license = licenses.asl20;
    maintainers = with maintainers; [ lucperkins ];
    broken = stdenv.isx86_64 && stdenv.isDarwin;
  };
}
