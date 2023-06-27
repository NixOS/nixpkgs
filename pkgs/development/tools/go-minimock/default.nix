{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-minimock";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "gojuno";
    repo = "minimock";
    rev = "v${version}";
    sha256 = "sha256-6n5FOHTfsLYqnhlDO3etMnrypeOElmwdvoFQb3aSBts=";
  };

  ldflags = [
    "-s" "-w" "-X main.version=${version}"
  ];

  vendorHash = "sha256-fiSU2NB9rWIPQLdnui5CB5VcadTVUg2JaO3ma7DAYqo=";

  doCheck = true;

  subPackages = [ "cmd/minimock" "." ];

  meta = with lib; {
    homepage = "https://github.com/gojuno/minimock";
    description = "A golang mock generator from interfaces";
    license = licenses.mit;
    maintainers = with maintainers; [ svrana ];
    mainProgram = "minimock";
  };
}
