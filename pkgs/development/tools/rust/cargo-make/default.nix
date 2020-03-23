{ stdenv, fetchurl, runCommand, fetchFromGitHub, rustPlatform, Security, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-make";
  version = "0.30.0";

  src =
    let
      source = fetchFromGitHub {
        owner = "sagiegurari";
        repo = pname;
        rev = version;
        sha256 = "0zlj2jys97nphymxrzdjmnh9vv7rsq3fgidap96mh26q9af7ffbz";
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

  cargoSha256 = "1y7fx3y47sba4cmkkmcr7zjlbvj0rhw5qi3pbn27gmxsvkg841s3";

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
