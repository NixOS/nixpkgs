{ lib
, buildNpmPackage
, fetchFromGitHub
, runCommand
, web-ext
}:

buildNpmPackage rec {
  pname = "web-ext";
  version = "7.11.0";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "web-ext";
    rev = version;
    hash = "sha256-tXYqAAzxAFQGREkNGgBrHLp7ukRDMtr0bPYW7hOEniY=";
  };

  npmDepsHash = "sha256-uKAEWe28zUgE7Fv00sGXD5dKje/pHh22yJlYtk+7tN8=";

  npmBuildFlags = [ "--production" ];

  passthru.tests.help = runCommand "${pname}-tests" { } ''
    ${web-ext}/bin/web-ext --help
    touch $out
  '';

  meta = {
    description = "A command line tool to help build, run, and test web extensions";
    homepage = "https://github.com/mozilla/web-ext";
    license = lib.licenses.mpl20;
    mainProgram = "web-ext";
    maintainers = with lib.maintainers; [ ];
  };
}
