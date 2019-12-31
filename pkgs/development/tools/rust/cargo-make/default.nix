{ stdenv, fetchurl, runCommand, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-make";
  version = "0.24.3";

  src =
    let
      source = fetchFromGitHub {
        owner = "sagiegurari";
        repo = pname;
        rev = version;
        sha256 = "1wcpk8b41v7j2z3vnn0nz18kkw4cm18k0qrnmn89h9cp5lpzfh8r";
      };
    in
    runCommand "cargo-make-src" {} ''
      cp -R ${source} $out
      chmod +w $out
      cp ${./Cargo.lock} $out/Cargo.lock
    '';

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "07xjxc9vzysl8zh7699ardmr7sqc8jsq0nzfvjsx6x2mjllkp67n";

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
