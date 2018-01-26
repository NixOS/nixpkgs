{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper, rustup, substituteAll }:

rustPlatform.buildRustPackage rec {
  name = "racer-${version}";
  version = "2.0.12";

  src = fetchFromGitHub {
    owner = "racer-rust";
    repo = "racer";
    rev = version;
    sha256 = "0y1xlpjr8y8gsmmrjlykx4vwzf8akk42g35kg3kc419ry4fli945";
  };

  cargoSha256 = "1h3jv4hajdv6k309kjr6b6298kxmd0faw081i3788sl794k9mp0j";

  # rustup is required for test
  buildInputs = [ makeWrapper rustup ];

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
  doCheck = true;

  meta = with stdenv.lib; {
    description = "A utility intended to provide Rust code completion for editors and IDEs";
    homepage = https://github.com/racer-rust/racer;
    license = licenses.mit;
    maintainers = with maintainers; [ jagajaga globin ];
    platforms = platforms.all;
  };
}
