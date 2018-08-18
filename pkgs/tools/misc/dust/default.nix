{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "dust-${version}";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "bootandy";
    repo = "dust";
    rev = "v${version}";
    sha256 = "1l8z1daiq2x92449p2ciblcwl0ddgr3vqj2dsd3z8jj3y0z8j51s";
  };

  cargoSha256 = "0x3ay440vbc64y3pd8zhd119sw8fih0njmkzpr7r8wdw3k48v96m";

  doCheck = false;

  meta = with stdenv.lib; {
    description = "du + rust = dust. Like du but more intuitive";
    homepage = https://github.com/bootandy/dust;
    license = licenses.asl20;
    maintainers = [ maintainers.infinisil ];
    platforms = platforms.all;
  };
}
