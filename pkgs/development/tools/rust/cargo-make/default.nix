{ stdenv, fetchurl, runCommand, fetchFromGitHub, rustPlatform, Security, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-make";
  version = "0.30.7";

  src =
    let
      source = fetchFromGitHub {
        owner = "sagiegurari";
        repo = pname;
        rev = version;
        sha256 = "0i8jf3161qqazp8cy3kzn2cw7zrcv1ijf2w3s8d8l0y2i2b25cv1";
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

  cargoSha256 = "08mn1ckvyffys9wqnvva7w1qzvarqvmnkpliv118vnnr072jnc6y";

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
