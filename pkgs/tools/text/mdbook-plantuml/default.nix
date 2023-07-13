{ lib
, fetchFromGitHub
, fetchpatch
, stdenv
, rustPlatform
, pkg-config
, openssl
, CoreServices
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-plantuml";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "sytsereitsma";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-26epwn6j/ZeMAphiFsrLjS0KIewvElr7V3p/EDr4Uqk=";
  };

  cargoPatches = [
    # https://github.com/sytsereitsma/mdbook-plantuml/pull/60
    (fetchpatch {
      name = "update-mdbook-for-rust-1.64.patch";
      url = "https://github.com/sytsereitsma/mdbook-plantuml/commit/a1c7fdaff65fbbcc086006f6d180b27e180739e7.patch";
      hash = "sha256-KXFQxogR6SaoX8snsSYMA8gn1FrQVKMl5l8khxB09WE=";
    })
  ];

  cargoHash = "sha256-3HlnhRexfFcAuk1RoatWORMJvYRrnoEft5ys6j3t9S0=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "mdBook preprocessor to render PlantUML diagrams to png images in the book output directory";
    homepage = "https://github.com/sytsereitsma/mdbook-plantuml";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ jcouyang ];
  };
}
