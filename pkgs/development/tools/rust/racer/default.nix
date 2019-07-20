{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper, substituteAll }:

rustPlatform.buildRustPackage rec {
  name = "racer-${version}";
  version = "2.0.14";

  src = fetchFromGitHub {
    owner = "racer-rust";
    repo = "racer";
    rev = version;
    sha256 = "0kgax74qa09axq7b175ph3psprgidwgsml83wm1qwdq16gpxiaif";
  };

  cargoSha256 = "119xfkglpfq26bz411rjj31i088vr0847p571cxph5v3dfxbgz4y";

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
  doCheck = true;

  meta = with stdenv.lib; {
    description = "A utility intended to provide Rust code completion for editors and IDEs";
    homepage = https://github.com/racer-rust/racer;
    license = licenses.mit;
    maintainers = with maintainers; [ jagajaga globin ];
    platforms = platforms.all;
  };
}
