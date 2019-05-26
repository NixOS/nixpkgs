{ stdenv, fetchurl, runCommand, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-make";
  version = "0.19.2";

  src =
    let
      source = fetchFromGitHub {
        owner = "sagiegurari";
        repo = pname;
        rev = version;
        sha256 = "175cflcm9k81fpp2pxz4hcaf8v3i7jqc9gcr4flnsqxjrh22vymp";
      };
      cargo-lock = fetchurl {
        url = "https://gist.githubusercontent.com/xrelkd/e4c9c7738b21f284d97cb7b1d181317d/raw/f1e6360acfbe5ae573f8f31a82a5c881a6f0ed68/cargo-make-Cargo.lock";
        sha256 = "004dx4gyby5smpvawqv946mambcg59zq6n8h89hz61mxkh7frmh4";
      };
    in
    runCommand "cargo-make-src" {} ''
      cp -R ${source} $out
      chmod +w $out
      cp ${cargo-lock} $out/Cargo.lock
    '';

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "1hmfg3x9p5a2vz2r3v8m5wgyabbybl5lcjvi930b9wi5cnfm756g";

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
