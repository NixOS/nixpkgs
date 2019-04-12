{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "0.4.10";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    sha256 = "1f90v67clmql2bb32sgs7c48q8nhyw2pfk4hpkiy8qll8fypjgik";
  };

  cargoSha256 = "042s28p68jz3my2q1crmq7xzcajwxmcprgg9z7r9ffhrybk4jvwz";

  meta = with stdenv.lib; {
    description = ''A utility and Cargo subcommand designed to let people expand macros in their Rust source code'';
    homepage = https://github.com/dtolnay/cargo-expand;
    license = with licenses; [ mit asl20 ];
    platforms = platforms.all;
    maintainers = with maintainers; [ xrelkd ];
  };
}
