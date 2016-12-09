{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper }:

with rustPlatform;

buildRustPackage rec {
  name = "rustfmt-${version}";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "rust-lang-nursery";
    repo = "rustfmt";
    rev = "61ab06a92eae355ed6447d85d3c416fb65e96bdb";
    sha256 = "0fa16ycbvhyxs1b278q8jizrx9z0gis0ysjwk8fjws0282xsyvbk";
  };

  depsSha256 = "1qg04nzba30fqswjf97wf0slai6lhrsy0bfv648sqnrf50virx5h";

  meta = with stdenv.lib; {
    description = "A tool for formatting Rust code according to style guidelines";
    homepage = https://github.com/rust-lang-nursery/rustfmt;
    license = with licenses; [ mit asl20 ];
    maintainers = [ maintainers.globin ];
    platforms = platforms.all;
  };
}
