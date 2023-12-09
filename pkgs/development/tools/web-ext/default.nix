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

  # Set `NODE_ENV=production` as described in the docs at
  # https://github.com/mozilla/web-ext/blob/7.6.2/CONTRIBUTING.md#build-web-ext
  # (Otherwise, this branch
  # https://github.com/mozilla/web-ext/blob/7.6.2/src/program.js#L396 will be
  # reached without git-rev-sync being available, as it's just a dev
  # dependency.)
  preBuild = "export NODE_ENV=production";

  meta = {
    description = "A command line tool to help build, run, and test web extensions";
    homepage = "https://github.com/mozilla/web-ext";
    license = lib.licenses.mpl20;
    mainProgram = "web-ext";
    maintainers = with lib.maintainers; [ ];
  };
}
