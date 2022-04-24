{ lib, stdenv, fetchCrate, rustPlatform, pkg-config, openssl, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-pdf";
  version = "0.1.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "1ibmn8x9kyfd058hsyah2ggyzpahzf2w2qjn6rs9qv8mr3bvc0pv";
  };

  cargoSha256 = "0k47a5yqnjjc599vgk39ijy6fm62rr8xarvz37g0c7fx9cljhihz";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ CoreServices ];

  # No test.
  doCheck = false;

  meta = with lib; {
    description = "A backend for mdBook written in Rust for generating PDF";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hollowman6 ];
    homepage = "https://github.com/HollowMan6/mdbook-pdf";
  };
}
