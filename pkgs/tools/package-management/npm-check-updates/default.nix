{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "npm-check-updates";
  version = "16.13.0";

  src = fetchFromGitHub {
    owner = "raineorshine";
    repo = "npm-check-updates";
    rev = "v${version}";
    hash = "sha256-RrNO1TAPNFB/6JWY8xZjNCZ+FDgM0MCn7vaDXoCSIfI=";
  };

  npmDepsHash = "sha256-aghW4d3/8cJmwpmI5PcHioCnc91Yu4N5EfwuoaB5Xqw=";

  meta = {
    changelog = "https://github.com/raineorshine/npm-check-updates/blob/${src.rev}/CHANGELOG.md";
    description = "Find newer versions of package dependencies than what your package.json allows";
    homepage = "https://github.com/raineorshine/npm-check-updates";
    license = lib.licenses.asl20;
    mainProgram = "ncu";
    maintainers = with lib.maintainers; [ flosse ];
  };
}
