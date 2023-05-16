{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hakari";
<<<<<<< HEAD
  version = "0.9.27";
=======
  version = "0.9.24";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "guppy-rs";
    repo = "guppy";
    rev = "cargo-hakari-${version}";
<<<<<<< HEAD
    sha256 = "sha256-H2vU7qax0P8Ulh1/DHnlmGRqSqzLuRy9TZOvikSLONw=";
  };

  cargoHash = "sha256-fRaGtQc9CA5A6fQ1yj5zsg1Qv42yIi8ZlIcp4o5cNBU=";
=======
    sha256 = "sha256-kg1iWku+zAXG9cCYCD4rqKzKNtDt0hMCnE5QyhJpLq8=";
  };

  cargoHash = "sha256-hrWsQXjWzhSVVj+bUviGEn+E7Lytzgf1r8VmQxJQubE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  cargoBuildFlags = [ "-p" "cargo-hakari" ];
  cargoTestFlags = [ "-p" "cargo-hakari" ];

  meta = with lib; {
    description = "Manage workspace-hack packages to speed up builds in large workspaces.";
    longDescription = ''
      cargo hakari is a command-line application to manage workspace-hack crates.
      Use it to speed up local cargo build and cargo check commands by 15-95%,
      and cumulatively by 20-25% or more.
    '';
    homepage = "https://crates.io/crates/cargo-hakari";
    changelog = "https://github.com/guppy-rs/guppy/blob/cargo-hakari-${version}/tools/cargo-hakari/CHANGELOG.md";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ figsoda macalinao ];
  };
}
