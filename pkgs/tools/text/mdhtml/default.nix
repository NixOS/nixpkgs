{ lib
, buildGoModule
, fetchFromGitea
}:

buildGoModule rec {
  pname = "mdhtml";
  version = "0.2.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "Tomkoid";
    repo = pname;
    rev = version;
    hash = "sha256-893pqrrTftzKqPYZgukV/yx2gkukVZWDTgg7ufx1MsY=";
  };

  vendorHash = null;

  meta = with lib; {
    description = "Really simple CLI Markdown to HTML converter with styling support";
    homepage = "https://codeberg.org/Tomkoid/mdhtml";
    license = licenses.mit;
    changelog = "https://codeberg.org/Tomkoid/mdhtml/releases";
    maintainers = with maintainers; [ tomkoid ];
    mainProgram = "mdhtml";
  };
}
