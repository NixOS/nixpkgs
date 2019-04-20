{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-bloat";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wf86r1s9skv0m4gp66g388847309nw9z1h8gadfg2c5w5idh3fb";
  };

  cargoSha256 = "1mmfcvpwwi6fjb47fz1azrpdkg1x5p3qn5bx4p6dyjcs1fmpdbbq";

  meta = with stdenv.lib; {
    description = "A tool and Cargo subcommand that helps you find out what takes most of the space in your executable";
    homepage = https://github.com/RazrFalcon/cargo-bloat;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ xrelkd ];
  };
}

