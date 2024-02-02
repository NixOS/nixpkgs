{ buildNpmPackage, fetchFromGitHub, lib, stdenv, testers, snyk }:

buildNpmPackage rec {
  pname = "snyk";
  version = "1.1274.0";

  src = fetchFromGitHub {
    owner = "snyk";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-cQIgHHulgjUxrl35dKEf7j9kZUp378rLmgwz4K8+Qy0=";
  };

  npmDepsHash = "sha256-Ji7zbmPNsqeXsC+mnYnfKL7m7mkXRAcwlaP+M8wWrIo=";

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
