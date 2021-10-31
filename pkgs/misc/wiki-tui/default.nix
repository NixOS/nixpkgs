{ lib, rustPlatform, fetchCrate, ncurses, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "wiki-tui";
  version = "0.3.4";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-H+C1AbZ2zUhw6TNlSPaNaNuY5iNf39JW4q2g6uolevM=";
  };

  buildInputs = [ ncurses openssl ];

  nativeBuildInputs = [ pkg-config ];

  cargoSha256 = "sha256-PIt592nGtNEREQMukqRl/6KSJ/P32fWucHEMyOOc7BA=";

  meta = with lib; {
    description = "A simple and easy to use Wikipedia Text User Interface";
    homepage = "https://github.com/builditluc/wiki-tui";
    license = licenses.mit;
    maintainers = with maintainers; [ legendofmiracles ];
    mainProgram = "wiki-tui";
  };
}
