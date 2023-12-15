{ lib
, buildGoModule
, fetchFromGitea
}:

buildGoModule rec {
  pname = "mdhtml";
  version = "0.3.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "Tomkoid";
    repo = pname;
    rev = version;
    hash = "sha256-ISZUadJZOWwUygLnGYvuMUNCmTNGZLYq+q/FeK++kWE=";
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
