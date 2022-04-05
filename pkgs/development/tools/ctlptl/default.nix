{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ctlptl";
  version = "0.8.6";

  src = fetchFromGitHub {
    owner = "tilt-dev";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FJtp4g4kIkXFYvYcM9yF3BY6tgHmip11/oIyMSfTwqM=";
  };

  vendorSha256 = "sha256-s+Cc7pG/GLK0ZhXX/wK7jMNcDIeu/Am2vCgzrNXKpdw=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "CLI for declaratively setting up local Kubernetes clusters";
    homepage = "https://github.com/tilt-dev/ctlptl";
    license = licenses.asl20;
    maintainers = with maintainers; [ svrana ];
  };
}
