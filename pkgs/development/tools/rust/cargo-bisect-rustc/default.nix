{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
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
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-E9birF4HmyDZKmwuTb5K4AMmvZQFTmnhFGSxD5bS2qQ=";
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
    lib.optionals stdenv.isLinux [ patchelfPatch ] ++ [
      (fetchpatch {
        name = "fix-cli-date-bounds-checking.patch";
        url = "https://github.com/rust-lang/cargo-bisect-rustc/commit/baffa98e1a1ae53f6f3605303e0d765015d9d3ae.patch";
        hash = "sha256-IQlwQvaPUzPK5T4Mbsrdt7Ea3elaPCw2pBCCdBhjtzM=";
      })
    ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  cargoHash = "sha256-7tqo8cxAzoDfTU372uW1qUhm+qqyRhz8bQ7oMiRU528=";

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
