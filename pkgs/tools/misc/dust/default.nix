{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "dust";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "bootandy";
    repo = "dust";
    rev = "v${version}";
    sha256 = "1l8z1daiq2x92449p2ciblcwl0ddgr3vqj2dsd3z8jj3y0z8j51s";
  };

  cargoSha256 = "1bby08ijpwb8676pgm87k80s0n0fqsxc3wmz0v8p9s85yzkflnx5";

  doCheck = false;

  meta = with stdenv.lib; {
    description = "du + rust = dust. Like du but more intuitive";
    homepage = https://github.com/bootandy/dust;
    license = licenses.asl20;
    maintainers = [ maintainers.infinisil ];
    platforms = platforms.all;
  };
}
