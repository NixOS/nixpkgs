{ stdenv, fetchurl, runCommand, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-make";
  version = "0.21.0";

  src =
    let
      source = fetchFromGitHub {
        owner = "sagiegurari";
        repo = pname;
        rev = version;
        sha256 = "02hxf0mbk4nj9ja1z70k8fskh1kl3pixwy7gx0si5fbp9rmn04wk";
      };
      cargo-lock = fetchurl {
        url = "https://gist.githubusercontent.com/xrelkd/e4c9c7738b21f284d97cb7b1d181317d/raw/b6017fd825b52987ac7c3b65620917e5d567312b/cargo-make-Cargo.lock";
        sha256 = "15ajxza58bbviwjxl98c0z89w4430902j0z46b594nbm02kv2ad9";
      };
    in
    runCommand "cargo-make-src" {} ''
      cp -R ${source} $out
      chmod +w $out
      cp ${cargo-lock} $out/Cargo.lock
    '';

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "1fsfjavad1cbq1xvck2j5vyppxck606cpmqrwbs4fjvdmlbgx3gp";

  # Some tests fail because they need network access.
  # However, Travis ensures a proper build.
  # See also:
  #   https://travis-ci.org/sagiegurari/cargo-make
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A Rust task runner and build tool";
    homepage = "https://github.com/sagiegurari/cargo-make";
    license = licenses.asl20;
    maintainers = with maintainers; [ xrelkd ];
    platforms = platforms.all;
  };
}
