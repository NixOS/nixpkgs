{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "oapi-codegen";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "deepmap";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-5Bwe0THxwynuUuw7jI7KBDNC1Q4sHlnWwO2Kx5F/7PA=";
  } ;

  vendorHash = "sha256-SqnFfx9bWneVEIyJS8fKe9NNcbPF4wI3qP5QvENqBrI=";

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
