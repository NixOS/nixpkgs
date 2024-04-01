{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "templ";
  version = "0.2.646";

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
    hash = "sha256-ocuDWdIHL4Ub1ybWBScg4ysTRQdvCxlod0TNuJFDA4o=";
  };

  vendorHash = "sha256-Upd5Wq4ajsyOMDiAWS2g2iNO1sm1XJc43AFQLIo5eDM=";

  meta = with lib; {
    description = "A language for writing HTML user interfaces in Go";
    homepage = "https://templ.guide/";
    license = licenses.mit;
    maintainers = with maintainers; [ luleyleo ];
    mainProgram = "templ";
  };
}
