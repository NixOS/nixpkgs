{ stdenv, fetchFromGitHub, rustPlatform, rustNightlyPlatform, makeWrapper, substituteAll }:

rustNightlyPlatform.buildRustPackage rec {
  name = "racer-${version}";
  version = "2.1.22";

  src = fetchFromGitHub {
    owner = "racer-rust";
    repo = "racer";
    rev = "v${version}";
    sha256 = "1n808h4jqxkvpjwmj8jgi4y5is5zvr8vn42mwb3yi13mix32cysa";
  };

  cargoSha256 = "0njaa9vk2i9g1c6sq20b7ls97nl532rfv3is7d8dwz51nrwk6jxs";

  buildInputs = [ makeWrapper ];

  preCheck = ''
    export RUST_SRC_PATH="${rustPlatform.rustcSrc}"
  '';
  patches = [
    (substituteAll {
      src = ./rust-src.patch;
      inherit (rustPlatform) rustcSrc;
    })
    ./ignore-tests.patch
  ];
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A utility intended to provide Rust code completion for editors and IDEs";
    homepage = https://github.com/racer-rust/racer;
    license = licenses.mit;
    maintainers = with maintainers; [ jagajaga globin ];
    platforms = platforms.all;
  };
}
