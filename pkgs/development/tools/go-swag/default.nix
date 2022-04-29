{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "go-swag";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "swaggo";
    repo = "swag";
    rev = "v${version}";
    sha256 = "sha256-axvc3iwAfsKunheLLKmUThZh27axRh/GJRcKy9EfEBw=";
  };

  vendorSha256 = "sha256-QphjiJSQRULphWjrJ8RzrUblTDYL/fYoSNT3+g0tP48=";

  subPackages = [ "cmd/swag" ];

  meta = with lib; {
    description = "Automatically generate RESTful API documentation with Swagger 2.0 for Go";
    homepage = "https://github.com/swaggo/swag";
    license = licenses.mit;
    maintainers = with maintainers; [ stephenwithph ];
  };
}
