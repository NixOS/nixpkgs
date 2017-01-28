{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper }:

with rustPlatform;

buildRustPackage rec {
  name = "rustfmt-${version}";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "rust-lang-nursery";
    repo = "rustfmt";
    rev = "907134c2d10c0f11608dc4820b023f8040ad655a";
    sha256 = "1sn590x6x93wjzkb78akqjim734hxynck3gmp8fx7gcrk5cch9mc";
  };

  depsSha256 = "1djpzgchl93radi52m89sjk2nbl9f4y15pwn4x78lqas0jlc6nlr";

  meta = with stdenv.lib; {
    description = "A tool for formatting Rust code according to style guidelines";
    homepage = https://github.com/rust-lang-nursery/rustfmt;
    license = with licenses; [ mit asl20 ];
    maintainers = [ maintainers.globin ];
    platforms = platforms.all;
  };
}
