{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "routinator";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "13xfnlaqjisi9fm1p7ydhgrh86ccbfwkxbnrv8abdx80jwb0lm15";
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
