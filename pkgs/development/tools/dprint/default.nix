{ lib, stdenv, fetchCrate, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "dprint";
<<<<<<< HEAD
  version = "0.40.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-kkGBSyLirHlJOzNh8GtY6k8kxpgouqHRQQEM/eDU7TA=";
  };

  cargoHash = "sha256-jImnU9ksYYmQOoaLBH+lMdoAsgo9ZFlu0tng61wrXXw=";
=======
  version = "0.36.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-9mHWQPe0HW1gSK0qbw/rBvh0t60ZEycrYywNGsPSrZE=";
  };

  cargoHash = "sha256-6v4DO0w+9SnAC+jIDgh8G5GstEG1F7vAgaG9XgPcyiU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    mainProgram = "dprint";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
