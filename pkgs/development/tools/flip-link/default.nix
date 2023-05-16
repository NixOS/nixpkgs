{ lib, stdenv, rustPlatform, fetchFromGitHub, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "flip-link";
<<<<<<< HEAD
  version = "0.1.7";
=======
  version = "0.1.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "knurling-rs";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-bwNtIuAALSOSUkbx2UbOEzHv064BVAHTBdJGPZVyEis=";
  };

  cargoHash = "sha256-pY1/p3TMt/DCTadU0Ki0yMgmS7RwO9siZLvNNXSLrfg=";
=======
    sha256 = "sha256-Sf2HlAfPlg8Er2g17AnRmUkvRhTw5AVPuL2B92hFvpA=";
  };

  cargoSha256 = "sha256-2VgsO2hUIvSPNQhR13+bGTxXa6xZXcK0amfiWv2EIxk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  checkFlags = [
    # requires embedded toolchains
    "--skip should_link_example_firmware::case_1_normal"
    "--skip should_link_example_firmware::case_2_custom_linkerscript"
    "--skip should_verify_memory_layout"
  ];

  meta = with lib; {
    description = "Adds zero-cost stack overflow protection to your embedded programs";
    homepage = "https://github.com/knurling-rs/flip-link";
    changelog = "https://github.com/knurling-rs/flip-link/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ FlorianFranzen newam ];
  };
}
