{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "routinator";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "1knqgq8xrlvwfc3y2hki6p0zr4dblm7max37y01p3bf641gs748z";
  };

  cargoSha256 = "13sx7mbirhrd0is7gvnk0mir5qizbhrlvsn0v55ibf3bybjsb644";

  meta = with stdenv.lib; {
    description = "An RPKI Validator written in Rust";
    homepage = "https://github.com/NLnetLabs/routinator";
    license = licenses.bsd3;
    maintainers = [ maintainers."0x4A6F" ];
    platforms = platforms.linux;
  };
}
