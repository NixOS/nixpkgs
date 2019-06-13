{ stdenv, fetchurl, runCommand, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-make";
  version = "0.19.5";

  src =
    let
      source = fetchFromGitHub {
        owner = "sagiegurari";
        repo = pname;
        rev = version;
        sha256 = "0xjyzsi3n3lb5g4gl6v0s4p87nazkqgjf244m792iji9i568ynjb";
      };
      cargo-lock = fetchurl {
        url = "https://gist.githubusercontent.com/xrelkd/e4c9c7738b21f284d97cb7b1d181317d/raw/285cf8f9b0ab33db0d656fdc8e759feed55c0167/cargo-make-Cargo.lock";
        sha256 = "0l2i2hq43k482m2w6hpapaq53r8bjljfcszp6csljj4fvxcl62yj";
      };
    in
    runCommand "cargo-make-src" {} ''
      cp -R ${source} $out
      chmod +w $out
      cp ${cargo-lock} $out/Cargo.lock
    '';

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "1rmdmvr5wc2m0yv3dy07cv9y1xrwlfri3hk97zjwv5f73wgncspy";

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
