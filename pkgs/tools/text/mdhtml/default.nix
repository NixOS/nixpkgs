{ lib
, buildGoModule
, fetchFromGitea
}:

buildGoModule rec {
  pname = "mdhtml";
  version = "0.3.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "Tomkoid";
    repo = pname;
    rev = version;
    hash = "sha256-Pzl6Hmc24uWQ02FQM84rsypTJy1GdvYqfLDjN6Ryq4Q=";
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
