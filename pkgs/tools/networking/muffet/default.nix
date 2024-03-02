{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "muffet";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "raviqqe";
    repo = "muffet";
    rev = "v${version}";
    hash = "sha256-kwEHabQYAaxC8nKewc5XHZnSvUSEQRw7qg0jtJoOw9g=";
  };

  vendorHash = "sha256-GNwyQHqyfuzKnNAv5gpZFmhSq+jIHdfeceLSD9UphdA=";

  meta = with lib; {
    description = "A website link checker which scrapes and inspects all pages in a website recursively";
    homepage = "https://github.com/raviqqe/muffet";
    changelog = "https://github.com/raviqqe/muffet/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "muffet";
  };
}
