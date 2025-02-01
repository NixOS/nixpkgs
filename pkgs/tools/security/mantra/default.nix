{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "mantra";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "MrEmpy";
    repo = "Mantra";
    rev = "refs/tags/v.${version}";
    hash = "sha256-wIFZgxl6qULDvdUeq4yiuc5dPDudKsYvVUewSL0ITNM=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Tool used to hunt down API key leaks in JS files and pages";
    homepage = "https://github.com/MrEmpy/Mantra";
    changelog = "https://github.com/MrEmpy/Mantra/releases/tag/v.${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "mantra";
  };
}
