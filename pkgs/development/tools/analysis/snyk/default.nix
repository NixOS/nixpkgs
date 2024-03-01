{ buildNpmPackage, fetchFromGitHub, lib, stdenv, testers, snyk }:

buildNpmPackage rec {
  pname = "snyk";
  version = "1.1280.1";

  src = fetchFromGitHub {
    owner = "snyk";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-bwEekB/jifSRktblvq98C3t2xSTTPn4NOftQs/T090U=";
  };

  npmDepsHash = "sha256-TtWc+Zy6yMHbDdsw5rVKK+RiCZ8ZuXyU+SfcPRgToiA=";

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
