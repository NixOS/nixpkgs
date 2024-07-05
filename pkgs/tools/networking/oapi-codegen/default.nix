{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "oapi-codegen";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "deepmap";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Gcl0i3K2ncrxMSLHCPWBleRGdVIVkUo7vcp+tDNpkOw=";
  } ;

  vendorHash = "sha256-urPMLEaisgndbHmS1sGQ07c+VRBdxIz0wseLoSLVWQo=";

  # Tests use network
  doCheck = false;

  subPackages = [ "cmd/oapi-codegen" ];

  ldflags = [ "-X main.noVCSVersionOverride=${version}" ] ;

  meta = with lib; {
    description = "Go client and server OpenAPI 3 generator";
    homepage = "https://github.com/deepmap/oapi-codegen";
    changelog = "https://github.com/deepmap/oapi-codegen/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ j4m3s ];
    mainProgram = "oapi-codegen";
  };
}
