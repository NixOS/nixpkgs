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

  meta = {
    description = "A command line tool to help build, run, and test web extensions";
    homepage = "https://github.com/mozilla/web-ext";
    license = lib.licenses.mpl20;
    mainProgram = "web-ext";
    maintainers = with lib.maintainers; [ ];
  };
}
