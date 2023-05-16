{ stdenv
, lib
, fetchFromGitHub
<<<<<<< HEAD
=======
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, rustPlatform
, pkg-config
, openssl
, runCommand
, patchelf
, zlib
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-bisect-rustc";
<<<<<<< HEAD
  version = "0.6.7";
=======
  version = "0.6.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-1edBGjnVsMNoP06HAEERQJ6HCkk0dRKlnt1b8GnJWsY=";
=======
    hash = "sha256-E9birF4HmyDZKmwuTb5K4AMmvZQFTmnhFGSxD5bS2qQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches =
    let
      patchelfPatch = runCommand "0001-dynamically-patchelf-binaries.patch"
        {
          CC = stdenv.cc;
          patchelf = patchelf;
          libPath = "$ORIGIN/../lib:${lib.makeLibraryPath [ zlib ]}";
        }
        ''
          export dynamicLinker=$(cat $CC/nix-support/dynamic-linker)
          substitute ${./0001-dynamically-patchelf-binaries.patch} $out \
            --subst-var patchelf \
            --subst-var dynamicLinker \
            --subst-var libPath
        '';
    in
<<<<<<< HEAD
    lib.optionals stdenv.isLinux [ patchelfPatch ];

  nativeBuildInputs = [ pkg-config ];

=======
    lib.optionals stdenv.isLinux [ patchelfPatch ] ++ [
      (fetchpatch {
        name = "fix-cli-date-bounds-checking.patch";
        url = "https://github.com/rust-lang/cargo-bisect-rustc/commit/baffa98e1a1ae53f6f3605303e0d765015d9d3ae.patch";
        hash = "sha256-IQlwQvaPUzPK5T4Mbsrdt7Ea3elaPCw2pBCCdBhjtzM=";
      })
    ];

  nativeBuildInputs = [ pkg-config ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

<<<<<<< HEAD
  cargoHash = "sha256-HzqGSuobGuIuLwoAPQJ1d6xUO2VJ0rcjfOYz2wdIbCk=";
=======
  cargoHash = "sha256-7tqo8cxAzoDfTU372uW1qUhm+qqyRhz8bQ7oMiRU528=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  checkFlags = [
    "--skip test_github"  # requires internet
  ];

  meta = with lib; {
    description = "Bisects rustc, either nightlies or CI artifacts";
    homepage = "https://github.com/rust-lang/cargo-bisect-rustc";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ davidtwco ];
  };
}
