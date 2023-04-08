{ lib, stdenv, fetchCrate, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "dprint";
  version = "0.34.5";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-kdpiOeXizCHLxEWlq991T6h7sbt0chu7Dou8V8yad94=";
  };

  cargoHash = "sha256-qzb2H9acWWIpG9tjFzU5ApHaBKfCYJcSSYjOWQnEebM=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

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
