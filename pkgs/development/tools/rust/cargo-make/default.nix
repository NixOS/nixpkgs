{ stdenv, fetchurl, runCommand, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-make";
  version = "0.19.4";

  src =
    let
      source = fetchFromGitHub {
        owner = "sagiegurari";
        repo = pname;
        rev = version;
        sha256 = "019dn401p4bds144fbvqxbnn8vswcj0lxr8cvgpxb2y22640z60l";
      };
      cargo-lock = fetchurl {
        url = "https://gist.githubusercontent.com/xrelkd/e4c9c7738b21f284d97cb7b1d181317d/raw/c5b9fde279a9f6d55d97e0ba4e0b4cd62e0ab2bf/cargo-make-Cargo.lock";
        sha256 = "1d5md3m8hxwf3pwvx059fsk1b3vvqm17pxbbyiisn9v4psrsmld5";
      };
    in
    runCommand "cargo-make-src" {} ''
      cp -R ${source} $out
      chmod +w $out
      cp ${cargo-lock} $out/Cargo.lock
    '';

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "0wf60ck0w3m9fa19dz99q84kw05sxlj2pp6bd8r1db3cfy8f8h8j";

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
