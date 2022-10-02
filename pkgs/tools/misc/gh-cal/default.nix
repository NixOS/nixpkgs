{ lib
, stdenv
, fetchCrate
, rustPlatform
, pkg-config
, openssl
, Security
}:
rustPlatform.buildRustPackage rec {
  pname = "gh-cal";
  version = "0.1.3";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-x9DekflZoXxH964isWCi6YuV3v/iIyYOuRYVgKaUBx0=";
  };

  cargoSha256 = "sha256-73gqk0DjhaLGIEP5VQQlubPomxHQyg4RnY5XTgE7msQ=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "GitHub contributions calender terminal viewer";
    homepage = "https://github.com/mrshmllow/gh-cal";
    license = licenses.mit;
    maintainers = with maintainers; [ loicreynier ];
  };
}
