{ stdenv, fetchurl, runCommand, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-make";
  version = "0.25.0";

  src =
    let
      source = fetchFromGitHub {
        owner = "sagiegurari";
        repo = pname;
        rev = version;
        sha256 = "1dvn3sjvvlllj99a94jl6yvdkv3a5qrrn3drdnx2s0v1w4djl5z4";
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
