{ stdenv
, lib
, fetchFromGitea
, rustPlatform
, makeWrapper
, protobuf
, darwin
, imagemagick
, ffmpeg
, exiftool
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "pict-rs";
  version = "0.5.11";

  src = fetchFromGitea {
    domain = "git.asonix.dog";
    owner = "asonix";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xZN9ifeI0cEz9i8JWTgvU0CZhukxwzJY6vwe7TJWkRc=";
  };

  cargoHash = "sha256-g1N7yziPbQthdNcwZeDbOQpGFePUf4LXqMyWkS6c1AQ=";

  # needed for internal protobuf c wrapper library
  PROTOC = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  postInstall = ''
    wrapProgram "$out/bin/pict-rs" \
        --prefix PATH : "${lib.makeBinPath [ imagemagick ffmpeg exiftool ]}"
  '';

  passthru.tests = { inherit (nixosTests) pict-rs; };

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A simple image hosting service";
    mainProgram = "pict-rs";
    homepage = "https://git.asonix.dog/asonix/pict-rs";
    license = with licenses; [ agpl3Plus ];
    maintainers = with maintainers; [ happysalada ];
  };
}
