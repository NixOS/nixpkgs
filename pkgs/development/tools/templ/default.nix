{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "templ";
  version = "0.2.476";

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
    hash = "sha256-lgeVfe+9kUxN4XXL7ANiFxtmupZwDaiRFABJIAclyd8=";
  };

  vendorHash = "sha256-hbXKWWwrlv0w3SxMgPtDBpluvrbjDRGiJ/9QnRKlwCE=";

  meta = with lib; {
    description = "A language for writing HTML user interfaces in Go";
    homepage = "https://templ.guide/";
    license = licenses.mit;
    maintainers = with maintainers; [ luleyleo ];
    mainProgram = "templ";
  };
}
