{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "diskus-${version}";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "diskus";
    rev = "cf4a5e0dc5bf3daedabe4b25343e7eb6238930c0";
    sha256 = "1w5fnpwdsfaca2177qn0clf8j7zwgzhdckjdl2zdbs5qrdwdqrd2";
  };

  cargoSha256 = "08wm85cs0fi03a75wp276w5hgch3kd787py51jjcxdanm2viq7zv";

  meta = with stdenv.lib; {
    description = "A minimal, fast alternative to 'du -sh'";
    homepage = https://github.com/sharkdp/diskus;
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.fuerbringer ];
    platforms = platforms.linux;
  };
}
