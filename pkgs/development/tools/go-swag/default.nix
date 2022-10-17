{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "go-swag";
  version = "1.8.6";

  src = fetchFromGitHub {
    owner = "swaggo";
    repo = "swag";
    rev = "v${version}";
    sha256 = "sha256-WpxKddCwlsOu1xL/HcxuA07oucYobRSJfoWHG2QieVQ=";
  };

  vendorSha256 = "sha256-RqhGGIwruAlrif2FZ+tvsicns56Ifjpy2ZHovDyjdB4=";

  subPackages = [ "cmd/swag" ];

  meta = with lib; {
    description = "Automatically generate RESTful API documentation with Swagger 2.0 for Go";
    homepage = "https://github.com/swaggo/swag";
    license = licenses.mit;
    maintainers = with maintainers; [ stephenwithph ];
    mainProgram = "swag";
  };
}
