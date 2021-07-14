{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "dprint";
  version = "0.15.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-1DUGp+HiiY03fyZ+b8hNUBIfuQV5Z/gEcOxc/vG3YiA=";
  };

  cargoSha256 = "sha256-twFXA8A+vP1n6IFJO78fKNs+FC2ui46rj1JmJ/eq3wc=";

  # Tests fail because they expect a test WASM plugin. Tests already run for
  # every commit upstream on GitHub Actions
  doCheck = false;

  meta = with lib; {
    description = "Code formatting platform written in Rust";
    longDescription = ''
      dprint is a pluggable and configurable code formatting platform written in Rust.
      It offers multiple WASM plugins to support various languages. It's written in
      Rust, so it’s small, fast, and portable.
    '';
    changelog = "https://github.com/dprint/dprint/releases/tag/${version}";
    homepage = "https://dprint.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ khushraj ];
  };
}
