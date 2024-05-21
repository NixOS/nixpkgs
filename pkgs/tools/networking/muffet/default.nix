{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "muffet";
  version = "2.10.1";

  src = fetchFromGitHub {
    owner = "raviqqe";
    repo = "muffet";
    rev = "v${version}";
    hash = "sha256-/LkXFY7ThPuq3RvW0NLZNRjk9kblFiztG98sTfhQuGM=";
  };

  vendorHash = "sha256-3kURSzwzM4QPCbb8C1vRb6Mr46XKNyZF0sAze5Z9xsg=";

  meta = with lib; {
    description = "A website link checker which scrapes and inspects all pages in a website recursively";
    homepage = "https://github.com/raviqqe/muffet";
    changelog = "https://github.com/raviqqe/muffet/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "muffet";
  };
}
