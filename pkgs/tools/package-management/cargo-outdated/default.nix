{ stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl, libiconv, curl, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-outdated";
  version = "0.9.11";

  src = fetchFromGitHub {
    owner = "kbknapp";
    repo = pname;
    rev = "v${version}";
    sha256 = "11fdh24366czb3vv2szf5bl0mhsilwvpfc1h4qxq18z2dpb0y18m";
  };

  cargoSha256 = "0sr3ijq6vh2269xav03d117kzmg68xiwqsq48xjdrsnn4dx5lizy";

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
