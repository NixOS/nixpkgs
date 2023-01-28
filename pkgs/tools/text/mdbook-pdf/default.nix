{ lib
, stdenv
, fetchCrate
, rustPlatform
, pkg-config
, openssl
, CoreServices
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-pdf";
  version = "0.1.4";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-v57Geqd1YCzR9oM97K+Y9OdeokzNc4Kbh0sDP0+vxjU=";
  };

  cargoHash = "sha256-mZUif1qBREM/5GYJU9m20p3rC3fnbZELcEKatwhoQEU=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    CoreServices
  ];

  # No test.
  doCheck = false;

  meta = with lib; {
    description = "A backend for mdBook written in Rust for generating PDF";
    homepage = "https://github.com/HollowMan6/mdbook-pdf";
    changelog = "https://github.com/HollowMan6/mdbook-pdf/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hollowman6 ];
  };
}
