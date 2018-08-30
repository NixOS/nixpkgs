{ stdenv, rustPlatform, fetchFromGitHub, cmake, pkgconfig, zlib, libiconv, darwin }:

rustPlatform.buildRustPackage rec {
  name    = "bat-${version}";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner  = "sharkdp";
    repo   = "bat";
    rev    = "v${version}";
    sha256 = "04ip0h1n7wavd7j7r7ppcy3v4987yv44mgw8qm8d56pcw67f9vwk";
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
