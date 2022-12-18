{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, zstd
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-about";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = "cargo-about";
    rev = version;
    sha256 = "sha256-8476jJK1oiXVX9G09NSL+xvXZdZ+h7grCHC6R0XXewo=";
  };

  cargoPatches = [
    # update mimalloc to fix build with older apple sdks
    ./update-mimalloc.patch

    # enable pkg-config feature of zstd
    ./zstd-pkg-config.patch
  ];

  cargoSha256 = "sha256-EFpkBWQSWYyMrUa9Dh+n9kDNmXL/2yuEmFN3DcPeE7U=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ zstd ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "Cargo plugin to generate list of all licenses for a crate";
    homepage = "https://github.com/EmbarkStudios/cargo-about";
    changelog = "https://github.com/EmbarkStudios/cargo-about/blob/${version}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ evanjs figsoda ];
  };
}
