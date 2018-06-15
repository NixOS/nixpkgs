{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "rust-cbindgen-${version}";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "eqrion";
    repo = "cbindgen";
    rev = "v${version}";
    sha256 = "0yzjbmdhhwbg551bm06xwwdjdm5kdqw37pgd7hals8qxb0dzmmh8";
  };

  cargoSha256 = "1ml4a7xp40l3bhfhpwdrwj3k99zhan9dzpkw71fa689xmv6pdj62";

  meta = with stdenv.lib; {
    description = "A project for generating C bindings from Rust code";
    homepage = https://github.com/eqrion/cbindgen;
    license = licenses.mpl20;
    maintainers = with maintainers; [ jtojnar ];
  };
}
