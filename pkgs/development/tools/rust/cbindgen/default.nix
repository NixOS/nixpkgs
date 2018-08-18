{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "rust-cbindgen-${version}";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "eqrion";
    repo = "cbindgen";
    rev = "v${version}";
    sha256 = "03qzqy3indqghqy7rnli1zrrlnyfkygxjpb2s7041cik54kf2krw";
  };

  cargoSha256 = "0c3xpzff8jldqbn5a25yy6c2hlz5xy636ml6sj5d24wzcgwg5a2i";

  meta = with stdenv.lib; {
    description = "A project for generating C bindings from Rust code";
    homepage = https://github.com/eqrion/cbindgen;
    license = licenses.mpl20;
    maintainers = with maintainers; [ jtojnar ];
  };
}
