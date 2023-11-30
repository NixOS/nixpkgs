{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "gh-eco";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "coloradocolby";
    repo = "gh-eco";
    rev = "v${version}";
    sha256 = "sha256-TE1AymNlxjUtkBnBO/VBjYaqLuRyxL75s6sMidKUXTE=";
  };

  vendorHash = "sha256-K85fYV1uP/qSw8GPoG1u6UQo94vQOUo4cd9Ro+UApQ0=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/coloradocolby/gh-eco";
    description = "gh extension to explore the ecosystem";
    license = licenses.mit;
    maintainers = with maintainers; [ helium ];
    mainProgram = "gh-eco";
  };
}

