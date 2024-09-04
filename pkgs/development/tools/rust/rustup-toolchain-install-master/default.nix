{ lib
, rustPlatform
, fetchFromGitHub
, runCommand
, stdenv
, patchelf
, zlib
, pkg-config
, openssl
, xz
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "rustup-toolchain-install-master";
  version = "1.7.3";

  src = fetchFromGitHub {
    owner = "kennytm";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-J25ER/g8Kylw/oTIEl4Gl8i1xmhR+4JM5M5EHpl1ras=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  patches =
    let
      patchelfPatch = runCommand "0001-dynamically-patchelf-binaries.patch" {
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
    xz
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  # update Cargo.lock to work with openssl 3
  postPatch = ''
    ln -sf ${./Cargo.lock} Cargo.lock
  '';

  meta = with lib; {
    description = "Install a rustc master toolchain usable from rustup";
    mainProgram = "rustup-toolchain-install-master";
    homepage = "https://github.com/kennytm/rustup-toolchain-install-master";
    license = licenses.mit;
    maintainers = with maintainers; [ davidtwco ];
  };
}
