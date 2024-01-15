{ lib
, buildNpmPackage
, fetchFromGitHub
, runCommand
, web-ext
}:

buildNpmPackage rec {
  pname = "web-ext";
  version = "7.10.0";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "web-ext";
    rev = version;
    hash = "sha256-VXvs4Z5cOt+lJ1JReApynpz/TufJgIVaO3dszS3Gvb4=";
  };

  npmDepsHash = "sha256-ovLVWOrQ//aJPJqzCJQS+/Tnn4Z75OR69e7ACevKWCA=";

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
