{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "rustfmt-${version}";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "rust-lang-nursery";
    repo = "rustfmt";
    rev = "${version}";
    sha256 = "12l3ff0s0pzhcf5jbs8wqawjk4jghhhz8j6dq1n5201yvny12jlr";
  };

  depsSha256 = "1nnb2lpzjf6hv1a7cw3cbkc22fb54rsp6h87wzmqi4hsy1csff7a";

  meta = with stdenv.lib; {
    description = "A tool for formatting Rust code according to style guidelines";
    homepage = https://github.com/rust-lang-nursery/rustfmt;
    license = with licenses; [ mit asl20 ];
    maintainers = [ maintainers.globin ];
    platforms = platforms.all;
  };
}
