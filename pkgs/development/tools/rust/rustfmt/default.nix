{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "rustfmt-${version}";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "rust-lang-nursery";
    repo = "rustfmt";
    rev = "${version}";
    sha256 = "1nh0h8mncz5vnn5hmw74f8nnh5cxdlrg67891l4dyq0p38vjhimz";
  };

  depsSha256 = "002d7y33a0bavd07wl7xrignmyaamnzfabdnr7a2x3zfizkfnblb";

  meta = with stdenv.lib; {
    description = "A tool for formatting Rust code according to style guidelines";
    homepage = https://github.com/rust-lang-nursery/rustfmt;
    license = with licenses; [ mit asl20 ];
    maintainers = [ maintainers.globin ];
    platforms = platforms.all;
  };
}
