{ stdenv
, lib
, fetchFromGitea
, rustPlatform
, makeWrapper
, protobuf
<<<<<<< HEAD
, darwin
=======
, Security
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, imagemagick
, ffmpeg
, exiftool
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "pict-rs";
<<<<<<< HEAD
  version = "0.4.2";
=======
  version = "0.3.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitea {
    domain = "git.asonix.dog";
    owner = "asonix";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-3iY16ld2yKf5PffaS1FUwhWD657OAdY4eWHe5f3fIuQ=";
  };

  cargoHash = "sha256-uRDRBe3rxkTSmO/uWSLQ6JI/t0KFta2kkf2ZihVYw0A=";
=======
    sha256 = "mEZBFDR+/aMRFw54Yq+f1gyEz8H+5IggNCpzv3UdDFg=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "aws-creds-0.29.1" = "bwDFmDPThMLrpaB7cAj/2/vJKhbX6/DqgcIRBVKSZhg=";
    };
  };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # needed for internal protobuf c wrapper library
  PROTOC = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";

  nativeBuildInputs = [ makeWrapper ];
<<<<<<< HEAD
  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks ];
=======
  buildInputs = lib.optionals stdenv.isDarwin [ Security ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postInstall = ''
    wrapProgram "$out/bin/pict-rs" \
        --prefix PATH : "${lib.makeBinPath [ imagemagick ffmpeg exiftool ]}"
  '';

  passthru.tests = { inherit (nixosTests) pict-rs; };

  meta = with lib; {
    description = "A simple image hosting service";
    homepage = "https://git.asonix.dog/asonix/pict-rs";
    license = with licenses; [ agpl3Plus ];
    maintainers = with maintainers; [ happysalada ];
  };
}
