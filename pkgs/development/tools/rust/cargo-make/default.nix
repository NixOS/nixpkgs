{ stdenv, fetchurl, runCommand, fetchFromGitHub, rustPlatform, Security, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-make";
  version = "0.31.0";

  src =
    let
      source = fetchFromGitHub {
        owner = "sagiegurari";
        repo = pname;
        rev = version;
        sha256 = "0svb3avmmkgwsv1dvzgzixp5fvcl93hn8xb3zx729jq8a47l2vsi";
      };
    in
    runCommand "source" {} ''
      cp -R ${source} $out
      chmod +w $out
      cp ${./Cargo.lock} $out/Cargo.lock
    '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "1n97j008rqzb96kh53r3fpvjlxy5m89fac5fvf2ka4nf68z5w0y5";

  # Some tests fail because they need network access.
  # However, Travis ensures a proper build.
  # See also:
  #   https://travis-ci.org/sagiegurari/cargo-make
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A Rust task runner and build tool";
    homepage = "https://github.com/sagiegurari/cargo-make";
    license = licenses.asl20;
    maintainers = with maintainers; [ xrelkd ma27 ];
    platforms = platforms.all;
  };
}
