{ lib, rustPlatform, fetchFromGitHub, stdenv, CoreServices, Security }:

rustPlatform.buildRustPackage rec {
  pname = "piping-server-rust";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "nwtgck";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QgOrKAPLphvIMqcOrbYuo4ra65IV8dK5+6tyh+YyyP4=";
  };

  cargoSha256 = "sha256-Nd+Frhospp6ERYFuxzEzKbkLAFqTv7Lp7MWwv09S+KA=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices Security ];

  meta = with lib; {
    description = "Infinitely transfer between every device over pure HTTP with pipes or browsers";
    homepage = "https://github.com/nwtgck/piping-server-rust";
    changelog = "https://github.com/nwtgck/piping-server-rust/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "piping-server";
  };
}
