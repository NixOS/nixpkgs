{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "go-swag";
  version = "1.16.3";

  src = fetchFromGitHub {
    owner = "swaggo";
    repo = "swag";
    rev = "v${version}";
    sha256 = "sha256-wS5m3dBiILxmVb6P559fGcONdCWc/5hhLAVMC+G1QZs=";
  };

  vendorHash = "sha256-BxWmEcx5IIT/yI46CJGE0vE1BRm5zwngc0x1dVy/04s=";

  subPackages = [ "cmd/swag" ];

  meta = with lib; {
    description = "Automatically generate RESTful API documentation with Swagger 2.0 for Go";
    homepage = "https://github.com/swaggo/swag";
    license = licenses.mit;
    maintainers = with maintainers; [ stephenwithph ];
    mainProgram = "swag";
  };
}
