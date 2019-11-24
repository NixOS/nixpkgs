{ stdenv, fetchFromGitHub, rustPlatform, Security, openssl, pkgconfig, libiconv, curl }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-crev";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "crev-dev";
    repo = "cargo-crev";
    rev = "v${version}";
    sha256 = "1vkqhjr8vw52wcxk575h39hp39ka3shx8hlxdkzpdbr40d126hdr";
  };

  cargoSha256 = "02bi6pzm1ys31zi1s5yzyw47dmdgclgkfjyyfa9h686640nakg8d";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ openssl ] ++ stdenv.lib.optionals stdenv.isDarwin [ Security libiconv curl ];

  meta = with stdenv.lib; {
    description = "A cryptographically verifiable code review system for the cargo (Rust) package manager";
    homepage = "https://github.com/crev-dev/cargo-crev";
    license = with licenses; [ asl20 mit mpl20 ];
    maintainers = with maintainers; [ b4dm4n ];
  };
}
