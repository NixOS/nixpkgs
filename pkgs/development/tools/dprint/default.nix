{
  lib,
  stdenv,
  fetchCrate,
  rustPlatform,
  testers,
  nix-update-script,
  dprint,
}:

rustPlatform.buildRustPackage rec {
  pname = "dprint";
  version = "0.47.5";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-1TfROcng9hF8j2PR+LEXNWnIKLapTPU1QunoCi5NxhI=";
  };

  cargoHash = "sha256-EliiKKRt+7IMPR8+0OWn+YKizPT9SZjVALAdbwi301w=";

  # Tests fail because they expect a test WASM plugin. Tests already run for
  # every commit upstream on GitHub Actions
  doCheck = false;

  passthru = {
    tests.version = testers.testVersion {
      inherit version;

      package = dprint;
      command = ''
        DPRINT_CACHE_DIR="$(mktemp --directory)" dprint --version
      '';
    };

    updateScript = nix-update-script { };
  };

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
