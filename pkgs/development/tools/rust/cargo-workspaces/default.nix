<<<<<<< HEAD
{ lib
, rustPlatform
, fetchCrate
, pkg-config
, libgit2_1_6
, libssh2
=======
{ fetchCrate
, lib
, rustPlatform
, pkg-config
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, openssl
, zlib
, stdenv
, darwin
<<<<<<< HEAD
=======
, libssh2
, libgit2
, IOKit
, Security
, CoreFoundation
, AppKit
, System
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-workspaces";
<<<<<<< HEAD
  version = "0.2.44";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-5r5XRb/RWHv0Am58VPOxe+QSKn2QT4JZYp5LjTh20KM=";
  };

  cargoHash = "sha256-p+7CWvspYk1LRO2s8Sstlven/2edNe+JYFQHaDFlGkM=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2_1_6
    libssh2
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  env = {
    LIBSSH2_SYS_USE_PKG_CONFIG = true;
  };
=======
  version = "0.2.35";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-MHoVeutoMaHHl1uxv52NOuvXsssqDuyfHTuyTqg9y+U=";
  };

  cargoSha256 = "sha256-wUVNsUx7JS5icjxbz3CV1lNUvuuL+gTL2QzuE+030WU=";
  verifyCargoDeps = true;

  # needed to get libssh2/libgit2 to link properly
  LIBGIT2_SYS_USE_PKG_CONFIG = true;
  LIBSSH2_SYS_USE_PKG_CONFIG = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl zlib libssh2 libgit2 ] ++ (
    lib.optionals stdenv.isDarwin ([ IOKit Security CoreFoundation AppKit ]
      ++ (lib.optionals stdenv.isAarch64 [ System ]))
  );
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A tool for managing cargo workspaces and their crates, inspired by lerna";
    longDescription = ''
      A tool that optimizes the workflow around cargo workspaces with
      git and cargo by providing utilities to version, publish, execute
      commands and more.
    '';
    homepage = "https://github.com/pksunkara/cargo-workspaces";
<<<<<<< HEAD
    changelog = "https://github.com/pksunkara/cargo-workspaces/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda macalinao matthiasbeyer ];
    mainProgram = "cargo-workspaces";
=======
    license = licenses.mit;
    maintainers = with maintainers; [ macalinao ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
