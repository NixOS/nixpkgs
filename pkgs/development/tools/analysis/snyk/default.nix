{ buildNpmPackage, fetchFromGitHub, lib, stdenv, testers, snyk }:

buildNpmPackage rec {
  pname = "snyk";
  version = "1.1269.0";

  src = fetchFromGitHub {
    owner = "snyk";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-jFaWkit96mIBCIYVOYoa5qNOP+fzmzwoi5bFgpi8JHM=";
  };

  npmDepsHash = "sha256-GCWpNFDfvpZrMLy8S7q1V0bzngL0fe0gZeMx+MbHOKU=";

  postPatch = ''
    substituteInPlace package.json --replace '"version": "1.0.0-monorepo"' '"version": "${version}"'
  '';

  env.NIX_CFLAGS_COMPILE =
    # Fix error: no member named 'aligned_alloc' in the global namespace
    lib.optionalString (stdenv.isDarwin && stdenv.isx86_64) "-D_LIBCPP_HAS_NO_LIBRARY_ALIGNED_ALLOCATION=1";

  npmBuildScript = "build:prod";

  passthru.tests.version = testers.testVersion {
    package = snyk;
  };

  meta = with lib; {
    description = "Scans and monitors projects for security vulnerabilities";
    homepage = "https://snyk.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
