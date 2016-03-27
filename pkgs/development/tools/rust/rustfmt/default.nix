{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper }:

with rustPlatform;

buildRustPackage rec {
  name = "rustfmt-${version}";
  version = "2016-03-22";

  src = fetchFromGitHub {
    owner = "rust-lang-nursery";
    repo = "rustfmt";
    rev = "ca757183fedf8e89286372b91ca074c11d99c4f4";
    sha256 = "0ngg5m002hwwmsqy9wr50dj3l3zgwk39701wzszm3nrhz6x13dmj";
  };

  depsSha256 = "0mg4z197iiwjlgqs5izacld25cr11qi3bcrqq204f0jzrnj3y8ag";

  meta = with stdenv.lib; {
    description = "A tool for formatting Rust code according to style guidelines";
    homepage = https://github.com/nrc/rustfmt;
    license = with licenses; [ mit asl20 ];
    maintainers = [ maintainers.globin ];
  };
}
