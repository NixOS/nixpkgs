{ lib
, stdenv
, fetchurl
, runCommand
, fetchCrate
, rustPlatform
, Security
, openssl
, pkg-config
, SystemConfiguration
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-make";
  version = "0.36.8";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-YLkeGLpNklXFOZ4bKn0GxWIEl9U77+PtAm8WxpDd1a4=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security SystemConfiguration libiconv ];

  cargoHash = "sha256-JSMBJYwm/QH1W6j4X+1YLnzKlGizsiu/NI2A1wTXpJk=";

  # Some tests fail because they need network access.
  # However, Travis ensures a proper build.
  # See also:
  #   https://travis-ci.org/sagiegurari/cargo-make
  doCheck = false;

  meta = with lib; {
    description = "A Rust task runner and build tool";
    homepage = "https://github.com/sagiegurari/cargo-make";
    license = licenses.asl20;
    maintainers = with maintainers; [ xrelkd ];
  };
}
