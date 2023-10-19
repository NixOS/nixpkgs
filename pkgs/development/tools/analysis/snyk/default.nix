{ buildNpmPackage, fetchFromGitHub, nodePackages, python3, lib }:

buildNpmPackage rec {
  pname = "snyk";
  version = "1.1207.0";

  src = fetchFromGitHub {
    owner = "snyk";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-wEXE+dcAfBK7fuoB23RdPSbJCaovB5sXrFO0QGyf+aw=";
  };

  npmDepsHash = "sha256-j3lMQh8++pb/00d9H2v7QBkpxIJdsuRQoFkNiQbvnF4=";

  nativeBuildInputs = [ nodePackages.node-gyp python3 ];

  npmBuildScript = "build:prod";

  meta = with lib; {
    description = "Scans and monitors projects for security vulnerabilities";
    homepage = "https://snyk.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
