{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper }:

with rustPlatform;

buildRustPackage rec {
  name = "xsv-${version}";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = "xsv";
    rev = "${version}";
    sha256 = "169rp4izcjhhlrqrhvlvsbiz7wqfi6g3kjfgrddgvahp0ls29hls";
  };

  depsSha256 = "006sp66l2gybyk1n7lxp645k6drz5cgxcix376k8qr0v9jwadlqa";

  meta = with stdenv.lib; {
    description = "A fast CSV toolkit written in Rust";
    homepage = https://github.com/BurntSushi/xsv;
    license = with licenses; [ unlicense ];
    maintainers = [ maintainers.jgertm ];
    platforms = platforms.all;
  };
}
