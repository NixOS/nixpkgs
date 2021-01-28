{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, CoreServices, Security, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-udeps";
  version = "0.1.17";

  src = fetchFromGitHub {
    owner = "est31";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qVmp2DTnQjvN5QWchiGa6huM30+o41zLmby45APfxgk=";
  };

  cargoSha256 = "sha256-zuJbs25lyDRTQPJdI0QBzO3xrdH48+cVhLqIkP7nLbE=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ CoreServices Security libiconv ];

  # Requires network access
  doCheck = false;

  meta = with lib; {
    description = "Find unused dependencies in Cargo.toml";
    homepage = "https://github.com/est31/cargo-udeps";
    license = licenses.mit;
    maintainers = with maintainers; [ b4dm4n ];
  };
}
