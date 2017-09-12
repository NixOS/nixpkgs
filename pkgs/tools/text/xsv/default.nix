{ stdenv, fetchFromGitHub, rustPlatform }:

with rustPlatform;

buildRustPackage rec {
  name = "xsv-${version}";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = "xsv";
    rev = "${version}";
    sha256 = "0z1z3b6nzaid510jaikkawvpmv4kjphzz84p0hppq6vcp5jy00s2";
  };

  depsSha256 = "13hy835871zxdnakwsr4bjm4krahlz4aqk5lh0rw78avfla89q9q";

  meta = with stdenv.lib; {
    description = "A fast CSV toolkit written in Rust";
    homepage = https://github.com/BurntSushi/xsv;
    license = with licenses; [ unlicense ];
    maintainers = [ maintainers.jgertm ];
    platforms = platforms.all;
  };
}
