{ lib, stdenv, rustPlatform, fetchFromGitHub, Security }:

rustPlatform.buildRustPackage rec {
  pname = "wagyu";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "ArgusHQ";
    repo = pname;
    rev = "v${version}";
    sha256 = "1646j0lgg3hhznifvbkvr672p3yqlcavswijawaxq7n33ll8vmcn";
  };

  cargoSha256 = "10al0j8ak95x4d85lzphgq8kmdnb809l6gahfp5miyvsfd4dxmpi";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Rust library for generating cryptocurrency wallets";
    homepage = "https://github.com/ArgusHQ/wagyu";
    license = with licenses; [ mit asl20 ];
    maintainers = [ maintainers.offline ];
  };
}
