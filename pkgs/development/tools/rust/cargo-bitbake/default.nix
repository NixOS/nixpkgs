{ lib, pkg-config, rustPlatform, fetchFromGitHub, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-bitbake";
  version = "0.3.15";

  src = fetchFromGitHub {
    owner = "meta-rust";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ffjkwaqvmyz374azrv6gna19z2fcg82is2k2n2gm50isbxw2aa5";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  cargoSha256 = "0mm6059wjh5p8923dwz55dpwi55gq2bcmpx7kn40pq5ppkiqjiw9";

  meta = with lib; {
    description = "Cargo extension that can generate BitBake recipes utilizing the classes from meta-rust";
    homepage = "https://github.com/meta-rust/cargo-bitbake";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ rvarago ];
    platforms = [ "x86_64-linux" ];
  };
}
