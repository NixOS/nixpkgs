{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "rust-cbindgen-${version}";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "eqrion";
    repo = "cbindgen";
    rev = "v${version}";
    sha256 = "0hifmn9578cf1r5m4ajazg3rhld2ybd2v48xz04vfhappkarv4w2";
  };

  cargoSha256 = "0c3xpzff8jldqbn5a25yy6c2hlz5xy636ml6sj5d24wzcgwg5a2i";

  meta = with stdenv.lib; {
    description = "A project for generating C bindings from Rust code";
    homepage = https://github.com/eqrion/cbindgen;
    license = licenses.mpl20;
    maintainers = with maintainers; [ jtojnar ];
  };
}
