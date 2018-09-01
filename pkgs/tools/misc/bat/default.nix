{ stdenv, rustPlatform, fetchFromGitHub, cmake, pkgconfig, zlib, libiconv, darwin }:

rustPlatform.buildRustPackage rec {
  name    = "bat-${version}";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner  = "sharkdp";
    repo   = "bat";
    rev    = "v${version}";
    sha256 = "19xmj3a3npx4v1mlvd31r3icml73mxjq6la5qifb2i35ciqnx9bd";
    fetchSubmodules = true;
  };

  cargoSha256 = "062vvpj514h85h9gm3jipp6z256cnnbxbjy7ja6bm7i6bpglyvvi";

  nativeBuildInputs = [ cmake pkgconfig zlib ];

  buildInputs = [ libiconv ] ++ stdenv.lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with stdenv.lib; {
    description = "A cat(1) clone with syntax highlighting and Git integration";
    homepage    = https://github.com/sharkdp/bat;
    license     = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dywedir ];
    platforms   = platforms.linux ++ platforms.darwin;
  };
}
