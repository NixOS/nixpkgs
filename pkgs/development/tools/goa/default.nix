{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "goa";
  version = "3.18.0";

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${version}";
    hash = "sha256-hteD8wxpkw27tduBUYkCIE+vgN/ggkIezEgFWqSuxbo=";
  };
  vendorHash = "sha256-AwpPuj/nX8MD//JL/oF+RGGQi1fdUo28KII2+y5Ptso=";

  subPackages = [ "cmd/goa" ];

  meta = with lib; {
    description = "Design-based APIs and microservices in Go";
    mainProgram = "goa";
    homepage = "https://goa.design";
    license = licenses.mit;
    maintainers = with maintainers; [ rushmorem ];
  };
}
