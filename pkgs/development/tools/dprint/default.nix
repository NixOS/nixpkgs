{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "dprint";
  version = "0.15.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-ftzV5babf3/l59CWDzVgUF2qws5yo1qEuepFLYd8psA=";
  };

  cargoSha256 = "sha256-ayCCNE44cOpbrk3FFtW2ZPZ1fTwzXwq3srmptI629sw=";

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
