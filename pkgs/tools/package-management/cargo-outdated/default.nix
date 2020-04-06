{ stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl, libiconv, curl, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-outdated";
  version = "0.9.8";

  src = fetchFromGitHub {
    owner = "kbknapp";
    repo = pname;
    rev = "v${version}";
    sha256 = "112yk46yq484zvr8mbj678qsirmyn2ij2h0z359qrhhl7r19icab";
  };

  cargoSha256 = "1bjs7lkbamy9za619z31ycqqgrfhvxbgfgpc79ykh4mfwphxzg3n";

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
