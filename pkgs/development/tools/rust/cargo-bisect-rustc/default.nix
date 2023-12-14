{ stdenv
, lib
, fetchFromGitHub
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
  version = "0.6.7";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-1edBGjnVsMNoP06HAEERQJ6HCkk0dRKlnt1b8GnJWsY=";
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
    lib.optionals stdenv.isLinux [ patchelfPatch ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  cargoHash = "sha256-HzqGSuobGuIuLwoAPQJ1d6xUO2VJ0rcjfOYz2wdIbCk=";

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
