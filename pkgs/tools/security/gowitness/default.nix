{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gowitness";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "sensepost";
    repo = "gowitness";
    rev = "refs/tags/${version}";
    hash = "sha256-yKG4qLjeZThFEMqMnUv4ryvM2e3uH5GLuVP3oa6XHtE=";
  };

  vendorHash = "sha256-PjbC10Dh3tDF0mP2k4ei6ZSS3ND2wAaB1+Llmj37TR8=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Web screenshot utility";
    homepage = "https://github.com/sensepost/gowitness";
    changelog = "https://github.com/sensepost/gowitness/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "gowitness";
  };
}
