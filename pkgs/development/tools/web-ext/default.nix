{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "web-ext";
  version = "7.6.2";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "web-ext";
    rev = version;
    hash = "sha256-tFMngcoHFA3QmR0AK68elUVpli37PsVlcL978o7DQCs=";
  };

  npmDepsHash = "sha256-KPBKUjCxva11w/E+Qhlx+1vikpCL7Hr9MiKenYHEVSU=";

  # web-ext defaults to development builds:
  #   https://github.com/mozilla/web-ext/blob/master/CONTRIBUTING.md#build-web-ext
  # Install dependencies with NODE_ENV=dev but build with NODE_ENV=production
  preBuild = ''
    export NODE_ENV=production
  '';

  meta = {
    description = "A command line tool to help build, run, and test web extensions";
    homepage = "https://github.com/mozilla/web-ext";
    license = lib.licenses.mpl20;
    mainProgram = "web-ext";
    maintainers = with lib.maintainers; [ ];
  };
}
