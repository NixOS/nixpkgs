{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "goa";
  version = "3.18.2";

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${version}";
    hash = "sha256-TBGCykHW++o2t4NFbWS3IK+UpXbyGgaJZ/6aoCrqi2Q=";
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
