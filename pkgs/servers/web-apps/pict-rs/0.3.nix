{ stdenv
, lib
, fetchFromGitea
, rustPlatform
, makeWrapper
, protobuf
, Security
, imagemagick
, ffmpeg
, exiftool
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "pict-rs";
  version = "0.3.3";

  src = fetchFromGitea {
    domain = "git.asonix.dog";
    owner = "asonix";
    repo = pname;
    rev = "v${version}";
    sha256 = "mEZBFDR+/aMRFw54Yq+f1gyEz8H+5IggNCpzv3UdDFg=";
  };

  cargoLock = {
    lockFile = ./Cargo-0.3.lock;
    outputHashes = {
      "aws-creds-0.29.1" = "bwDFmDPThMLrpaB7cAj/2/vJKhbX6/DqgcIRBVKSZhg=";
    };
  };

  # needed for internal protobuf c wrapper library
  PROTOC = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  postInstall = ''
    wrapProgram "$out/bin/pict-rs" \
        --prefix PATH : "${lib.makeBinPath [ imagemagick ffmpeg exiftool ]}"
  '';

  passthru.tests = { inherit (nixosTests) pict-rs; };

  meta = with lib; {
    description = "Simple image hosting service";
    mainProgram = "pict-rs";
    homepage = "https://git.asonix.dog/asonix/pict-rs";
    license = with licenses; [ agpl3Plus ];
    maintainers = with maintainers; [ happysalada ];
  };
}
