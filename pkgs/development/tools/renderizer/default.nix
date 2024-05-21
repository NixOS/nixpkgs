{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "renderizer";
  version = "2.0.13";

  src = fetchFromGitHub {
    owner = "gomatic";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-jl98LuEsGN40L9IfybJhLnbzoYP/XpwFVQnjrlmDL9A=";
  };

  ldflags = [
    "-s" "-w" "-X main.version=${version}" "-X main.commitHash=${src.rev}" "-X main.date=19700101T000000"
  ];

  vendorHash = null;

  meta = with lib; {
    description = "CLI to render Go template text files";
    mainProgram = "renderizer";
    inherit (src.meta) homepage;
    license = licenses.gpl3;
    maintainers = [];
  };
}
