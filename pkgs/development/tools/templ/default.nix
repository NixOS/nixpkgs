{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "templ";
  version = "0.2.513";

  subPackages = [ "cmd/templ" ];

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-extldflags -static"
  ];

  src = fetchFromGitHub {
    owner = "a-h";
    repo = "templ";
    rev = "refs/tags/v${version}";
    hash = "sha256-LWvwtAX1KBK33FIyY6alkG0RBXL6Ce4fR0cklQfwaRk=";
  };

  vendorHash = "sha256-buJArvaaKGRg3yS7BdcVY0ydyi4zah57ABeo+CHkZQU=";

  meta = with lib; {
    description = "A language for writing HTML user interfaces in Go";
    homepage = "https://templ.guide/";
    license = licenses.mit;
    maintainers = with maintainers; [ luleyleo ];
    mainProgram = "templ";
  };
}
