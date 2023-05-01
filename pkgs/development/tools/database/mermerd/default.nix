{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "mermerd";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "KarnerTh";
    repo = "mermerd";
    rev = "refs/tags/v${version}";
    hash = "sha256-nlertvmuP9Fiuc4uVrgKzfxjOY/sE9udKZLe51t0GEY=";
  };

  vendorHash = "sha256-RSCpkQymvUvY2bOkjhsyKnDa3vezUjC33Nwv0+O4OOQ=";

  # the tests expect a database to be running
  doCheck = false;

  meta = with lib; {
    description = "Create Mermaid-Js ERD diagrams from existing tables";
    homepage = "https://github.com/KarnerTh/mermerd";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ austin-artificial ];
    changelog = "https://github.com/KarnerTh/mermerd/releases/tag/v${version}";
  };

}
