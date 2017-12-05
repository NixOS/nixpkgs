{ stdenv, fetchFromGitHub, rustPlatform }:

with rustPlatform;

buildRustPackage rec {
  name = "xsv-${version}";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = "xsv";
    rev = "${version}";
    sha256 = "0xmjx5grwjrx2zsqmpblid9pqpwkk9pv468ffqlza3w35n9x5dax";
  };

  depsSha256 = "0gdbxgykhy6wm89mbdvl7ck2v0f66hwlm0m1q7r64bkb7i10fmkd";

  meta = with stdenv.lib; {
    description = "A fast CSV toolkit written in Rust";
    homepage = https://github.com/BurntSushi/xsv;
    license = with licenses; [ unlicense ];
    maintainers = [ maintainers.jgertm ];
    platforms = platforms.all;
  };
}
