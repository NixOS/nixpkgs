{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-bloat";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = pname;
    rev = "v${version}";
    sha256 = "169x90jrd2izj29xczja8pca984i6jgyx3ihfpd7cb1gw30rggbg";
  };

  cargoSha256 = "12cbc5bdzvcjh2d00d1ma91crbjwzas9rv8xxnnh850rjz8h684h";

  meta = with stdenv.lib; {
    description = "A tool and Cargo subcommand that helps you find out what takes most of the space in your executable";
    homepage = https://github.com/RazrFalcon/cargo-bloat;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ xrelkd ];
  };
}

