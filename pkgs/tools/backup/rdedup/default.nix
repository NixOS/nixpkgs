{ lib, stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl, libsodium
<<<<<<< HEAD
, xz
=======
, llvmPackages, clang, xz
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, Security }:

rustPlatform.buildRustPackage rec {
  pname = "rdedup";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "dpc";
    repo = "rdedup";
    rev = "v${version}";
    sha256 = "sha256-GEYP18CaCQShvCg8T7YTvlybH1LNO34KBxgmsTv2Lzs=";
  };

  cargoSha256 = "sha256-I6d3IyPBcUsrvlzF7W0hFM4hcXi4wWro9bCeP4eArHI=";

<<<<<<< HEAD
  nativeBuildInputs = [ pkg-config rustPlatform.bindgenHook ];
  buildInputs = [ openssl libsodium xz ]
    ++ (lib.optional stdenv.isDarwin Security);

=======
  nativeBuildInputs = [ pkg-config llvmPackages.libclang clang ];
  buildInputs = [ openssl libsodium xz ]
    ++ (lib.optional stdenv.isDarwin Security);

  configurePhase = ''
    export LIBCLANG_PATH="${llvmPackages.libclang.lib}/lib"
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Data deduplication with compression and public key encryption";
    homepage = "https://github.com/dpc/rdedup";
    license = licenses.mpl20;
    maintainers = with maintainers; [ dywedir ];
  };
}
