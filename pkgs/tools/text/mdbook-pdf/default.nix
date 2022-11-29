{ lib, stdenv, fetchCrate, rustPlatform, pkg-config, openssl, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-pdf";
  version = "0.1.3";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-zFeEmIv3DIYKmhVYO9cJwRQbSP8yELaJjVjP7hYegco=";
  };

  cargoHash = "sha256-pB7NEloeow4TE1Y1EMUZzeCJ/f4DnCS+sQlyN49gqzA=";

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
