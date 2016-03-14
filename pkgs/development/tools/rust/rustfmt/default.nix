{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper }:

with rustPlatform;

buildRustPackage rec {
  name = "rustfmt-git-2016-02-15";
  src = fetchFromGitHub {
    owner = "rust-lang-nursery";
    repo = "rustfmt";
    rev = "65bc5c242de86f0651b34fd913ca338a880696e8";
    sha256 = "02rdim0y5zg1r2zkfy6kj53idlbdybf3ckardbjsvdna5idc1hpz";
  };

  depsSha256 = "1297vy5sgiq4xqdm27pa8f99qiwrl15hb2r1dydzgk7n4iqyir6c";

  meta = with stdenv.lib; {
    description = "A tool for formatting Rust code according to style guidelines";
    homepage = https://github.com/nrc/rustfmt;
    license = with licenses; [ mit asl20 ];
    maintainers = [ maintainers.globin ];
  };
}
