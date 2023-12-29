{ lib
, buildNpmPackage
, fetchFromGitHub
, runCommand
, web-ext
}:

buildNpmPackage rec {
  pname = "web-ext";
  version = "7.9.0";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "web-ext";
    rev = version;
    hash = "sha256-7fBUWQFUsIGQnyNhZISvdtAQMAMZ38mbzGuC+6Cwu1Y=";
  };

  npmDepsHash = "sha256-3Dq4sNPZm9fDxPxOZL+rDxFA/FEs2/+zdz8sF3JFJ3s=";

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
