{ stdenv, rustPlatform, fetchFromGitHub, cmake, pkgconfig, zlib, libiconv, darwin }:

rustPlatform.buildRustPackage rec {
  name    = "bat-${version}";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner  = "sharkdp";
    repo   = "bat";
    rev    = "v${version}";
    sha256 = "0ms1hmv6qx15p47l07h7szwq0bgphhskc0xca2l641159h55r6dg";
    fetchSubmodules = true;
  };

  cargoSha256 = "1dzm44kcx3plh74qr4wghl3wqwr62hcxzlcv7mhh0vvk3z36c8d4";

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
