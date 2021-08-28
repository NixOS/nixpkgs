{ lib, stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-whatfeatures";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "museun";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vki37pxngg15za9c1z61dc6sqk0j59s0qhcf9hplnym4ib5kqx1";
  };

  cargoSha256 = "sha256-ZEkSj/JzXXTHjaxBVS5RDk/ECvOPPjzH4eS3CmlQA9I=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "A simple cargo plugin to get a list of features for a specific crate";
    homepage = "https://github.com/museun/cargo-whatfeatures";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ ivan-babrou ];
  };
}
