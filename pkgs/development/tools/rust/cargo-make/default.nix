{ stdenv, fetchurl, runCommand, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-make";
  version = "0.19.3";

  src =
    let
      source = fetchFromGitHub {
        owner = "sagiegurari";
        repo = pname;
        rev = version;
        sha256 = "11mkfwvzsr86w9675zpq8gcq5avsfvwffca26h6gkc7ahqcsx3ac";
      };
      cargo-lock = fetchurl {
        url = "https://gist.githubusercontent.com/xrelkd/e4c9c7738b21f284d97cb7b1d181317d/raw/3592410d14443cc6be675553a9c228401114fa5f/cargo-make-Cargo.lock";
        sha256 = "0m8m2pn8y7n1js1kkva4lxahz5j4d73lj7l45h8dd30lw2w4n3hg";
      };
    in
    runCommand "cargo-make-src" {} ''
      cp -R ${source} $out
      chmod +w $out
      cp ${cargo-lock} $out/Cargo.lock
    '';

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "00yvx87s8vngb97ldq2amdhdv3nn38liys7nilay73phx0xybx4p";

  # Some tests fail because they need network access.
  # However, Travis ensures a proper build.
  # See also:
  #   https://travis-ci.org/sagiegurari/cargo-make
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A Rust task runner and build tool";
    homepage = https://github.com/sagiegurari/cargo-make;
    license = licenses.asl20;
    maintainers = with maintainers; [ xrelkd ];
    platforms = platforms.all;
  };
}
