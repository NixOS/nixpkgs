{ lib, fetchFromGitHub, rustPlatform, stdenv, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-fuzz";
<<<<<<< HEAD
  version = "0.11.2";
=======
  version = "0.11.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "rust-fuzz";
    repo = "cargo-fuzz";
<<<<<<< HEAD
    rev = version;
    sha256 = "sha256-qbeNQM3ODkstXQTbrCv8bbkwYDBU/HB+L1k66vY4494=";
  };

  cargoSha256 = "sha256-1CTwVHOG8DOObfaGK1eGn9HDM755hf7NlqheBTJcCig=";
=======
    rev = "v${version}";
    sha256 = "sha256-vjKo0L7sYrC7qWdOGSJDWpL04tmNjO3QRwAIRHN/DiI=";
  };

  cargoSha256 = "sha256-8XVRMwrBEJ1duQtXzNpuN5wJPUgziJlka4n/nAIqeEc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  doCheck = false;

  meta = with lib; {
    description = "Command line helpers for fuzzing";
    homepage = "https://github.com/rust-fuzz/cargo-fuzz";
    license = with licenses; [ mit asl20 ];
<<<<<<< HEAD
    maintainers = with maintainers; [ ekleog matthiasbeyer ];
=======
    maintainers = [ maintainers.ekleog ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
