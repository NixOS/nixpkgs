{ stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl, libiconv, curl, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-outdated";
  version = "0.9.9";

  src = fetchFromGitHub {
    owner = "kbknapp";
    repo = pname;
    rev = "v${version}";
    sha256 = "01yvkfclrynv7gpvdckzbcv03xr28yb4v6333a6nv6gy05p26g3a";
  };

  cargoSha256 = "152f2f16d5vlww51aldvh1r2r4kx8ad5d48dc30xsfj669zzw24h";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ]
  ++ stdenv.lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    libiconv
    curl
  ];

  meta = with stdenv.lib; {
    description = "A cargo subcommand for displaying when Rust dependencies are out of date";
    homepage = "https://github.com/kbknapp/cargo-outdated";
    license = with licenses; [ asl20 /* or */ mit ];
    platforms = platforms.all;
    maintainers = with maintainers; [ sondr3 ivan ];
  };
}
