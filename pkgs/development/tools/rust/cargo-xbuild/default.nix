{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-xbuild";
<<<<<<< HEAD
  version = "0.6.6";
=======
  version = "0.6.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "rust-osdev";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-29rCjmzxxIjR5nBN2J3xxP+r8NnPIJV90FkSQQEBbo4=";
  };

  cargoHash = "sha256-tyPhKWDSDNxQy+vpWNS5VP5D8TkUR7MJSAlG8wZsDy4=";
=======
    sha256 = "sha256-bnceN47OFGlxs3ibcKoZFjoTgXRQxA2ZqxnthJ/fsqE=";
  };

  cargoSha256 = "sha256-qMPJC61ZVW9olMgNnGrvcQ/je4se4J5gOVoaOpNMUo8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Automatically cross-compiles the sysroot crates core, compiler_builtins, and alloc";
    homepage = "https://github.com/rust-osdev/cargo-xbuild";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ johntitor xrelkd ];
  };
}
