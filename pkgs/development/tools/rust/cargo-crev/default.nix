{ stdenv, fetchFromGitHub, rustPlatform, Security, openssl, pkgconfig, libiconv, curl }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-crev";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "crev-dev";
    repo = "cargo-crev";
    rev = "v${version}";
    sha256 = "1vf78hrc84xgr73r72vmilh24s4qy80a1z6gyk97nd8ipn93m2k5";
  };

  cargoSha256 = "0h7izq4sq6nf0gip7ylyglq1mvpfipm4qmjsifb3x559lqwfbxli";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ openssl ] ++ stdenv.lib.optionals stdenv.isDarwin [ Security libiconv curl ];

  meta = with stdenv.lib; {
    description = "A cryptographically verifiable code review system for the cargo (Rust) package manager";
    homepage = "https://github.com/crev-dev/cargo-crev";
    license = with licenses; [ asl20 mit mpl20 ];
    maintainers = with maintainers; [ b4dm4n ];
  };
}
