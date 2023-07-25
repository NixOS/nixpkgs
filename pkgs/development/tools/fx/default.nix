{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fx";
  version = "24.1.0";

  src = fetchFromGitHub {
    owner = "antonmedv";
    repo = pname;
    rev = version;
    hash = "sha256-X6wuCAiQa1coHMz96aAXKGZFnius1vHJpk+EhbXqoMA=";
  };

  vendorHash = "sha256-J19MhLvjxcxvcub888UFKI0iIf7OG3dmP5v40ElHCU4=";

  meta = with lib; {
    description = "Terminal JSON viewer";
    homepage = "https://github.com/antonmedv/fx";
    changelog = "https://github.com/antonmedv/fx/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
