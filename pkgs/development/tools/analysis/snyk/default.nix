{ lib
, buildNpmPackage
, fetchFromGitHub
, stdenv
, testers
, snyk
}:

buildNpmPackage rec {
  pname = "snyk";
  version = "1.1293.0";

  src = fetchFromGitHub {
    owner = "snyk";
    repo = "cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-zCDxq+aP7StfgXTg6G/J4o5xjcKI4ak3N3Dh8cIUK8U=";
  };

  npmDepsHash = "sha256-XPJoDhCncucFTv1B+YlMQxh3KkXleQGRvcSuYrXcL4g=";

  postPatch = ''
    substituteInPlace package.json \
      --replace-fail '"version": "1.0.0-monorepo"' '"version": "${version}"'
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
    changelog = "https://github.com/snyk/cli/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "snyk";
  };
}
