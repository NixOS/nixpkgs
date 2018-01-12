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

  cargoSha256 = "0pdzh2xr40dgwravh3i58g602bpszj6c8inggzgmq2kfk8ck6rgj";

  meta = with stdenv.lib; {
    description = "A fast CSV toolkit written in Rust";
    homepage = https://github.com/BurntSushi/xsv;
    license = with licenses; [ unlicense ];
    maintainers = [ maintainers.jgertm ];
    platforms = platforms.all;
  };
}
