{
  lib,
  stdenv,
  fetchCrate,
  rustPlatform,
  CoreFoundation,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "dprint";
  version = "0.45.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-dVtUUQ9AUQ85vsFwDb3xnR3UWxvSDMosC8QPW8AGHf4=";
  };

  cargoHash = "sha256-NXofEGJ1Sn7xnn8xxD9ZXBjoG/ZJgWvP0vCAJiwxK38=";

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreFoundation
    Security
  ];

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
    mainProgram = "dprint";
  };
}
