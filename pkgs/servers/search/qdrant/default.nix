{ lib
, rustPlatform
, fetchFromGitHub
, protobuf
, stdenv
, pkg-config
, openssl
, nix-update-script
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "qdrant";
<<<<<<< HEAD
  version = "1.5.1";
=======
  version = "1.1.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "qdrant";
    repo = "qdrant";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    sha256 = "sha256-CWE3tCeLJjtuFcvnGLdODtx0mvVSl2ULIcxgf3X3SPU=";
=======
    sha256 = "sha256-CGGJLyhhwQvW9AIzA7Fg85CvPbnuyELR+mmhoc4hJtk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
<<<<<<< HEAD
      "quantization-0.1.0" = "sha256-FfjLNSPjgVTx2ReqqMeyYujnCz9fPgjWX99r3Lik8oA=";
      "tonic-0.9.2" = "sha256-ZlcDUZy/FhxcgZE7DtYhAubOq8DMSO17T+TCmXar1jE=";
      "wal-0.1.2" = "sha256-sMleBUAZcSnUx7/oQZr9lSDmVHxUjfGaVodvVtFEle0=";
    };
  };

=======
      "quantization-0.1.0" = "sha256-4TY08ScRbL4zVG428BTZu42ocAsPk/8wM+zzI8EFSrs=";
      "wal-0.1.2" = "sha256-EfCvwgHMfyiId8VjV+yFyNqoIv6fxF8UFcw1s46hF5k=";
    };
  };

  prePatch = lib.optionalString stdenv.isAarch64 ''
    substituteInPlace .cargo/config.toml \
      --replace "[target.aarch64-unknown-linux-gnu]" "" \
      --replace "linker = \"aarch64-linux-gnu-gcc\"" ""
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];

  nativeBuildInputs = [ protobuf rustPlatform.bindgenHook pkg-config ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-faligned-allocation";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Vector Search Engine for the next generation of AI applications";
    longDescription = ''
      Expects a config file at config/config.yaml with content similar to
      https://github.com/qdrant/qdrant/blob/master/config/config.yaml
    '';
    homepage = "https://github.com/qdrant/qdrant";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
