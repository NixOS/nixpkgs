{ lib
, buildNpmPackage
, fetchFromGitHub
, runCommand
, web-ext
}:

buildNpmPackage rec {
  pname = "web-ext";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "web-ext";
    rev = version;
    hash = "sha256-lMfvD5EVWpDcX54nJI3eReF/EMMuZYxtKdHKwk4Lrxk=";
  };

  npmDepsHash = "sha256-RVyIpzVom48/avot9bbjXYg2E5+b3GlCHaKNfMEk968=";

  npmBuildFlags = [ "--production" ];

  passthru.tests.help = runCommand "${pname}-tests" { } ''
    ${web-ext}/bin/web-ext --help
    touch $out
  '';

  meta = {
    description = "Command line tool to help build, run, and test web extensions";
    homepage = "https://github.com/mozilla/web-ext";
    license = lib.licenses.mpl20;
    mainProgram = "web-ext";
    maintainers = with lib.maintainers; [ ];
  };
}
