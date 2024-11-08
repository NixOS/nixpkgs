{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "muffet";
  version = "2.10.3";

  src = fetchFromGitHub {
    owner = "raviqqe";
    repo = "muffet";
    rev = "v${version}";
    hash = "sha256-+g8DXvNWs7tqgxeZl7FWudbZRRx9N4/Cb6jQkuxnI98=";
  };

  vendorHash = "sha256-JMQgDG0MQuDJBrcz7uf872bXkz4BM+bC1v/GhkuxeYU=";

  meta = with lib; {
    description = "Website link checker which scrapes and inspects all pages in a website recursively";
    homepage = "https://github.com/raviqqe/muffet";
    changelog = "https://github.com/raviqqe/muffet/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "muffet";
  };
}
