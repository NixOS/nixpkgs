{ lib
, buildNpmPackage
, fetchFromGitHub
, stdenv
, testers
, snyk
}:

buildNpmPackage rec {
  pname = "snyk";
  version = "1.1293.1";

  src = fetchFromGitHub {
    owner = "snyk";
    repo = "cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-Vgt9h0LLIC5I9NZZKKWD9b1xnNOSkxApLxSGf2C0ODk=";
  };

  npmDepsHash = "sha256-1YtyQg14vj85KtOXP93vLkqIMmT+8DAJdG/ql+1ooyU=";

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
