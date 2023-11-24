{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "ejs";
  version = "3.1.9";

  src = fetchFromGitHub {
    owner = "mde";
    repo = "ejs";
    rev = "v${version}";
    hash = "sha256-bOZclhsnV3onxc32ZGfLpuGS5Jz6S12/BmkmwL4M6Dg=";
  };

  npmDepsHash = "sha256-829eWfJiMw9KRlhdmzD0ha//bgUQ5nPEzO+ayUPLxXY=";

  buildPhase = ''
    runHook preBuild

    ./node_modules/.bin/jake build

    runHook postBuild
  '';

  meta = {
    description = "Embedded JavaScript templates";
    homepage = "http://ejs.co";
    license = lib.licenses.asl20;
    mainProgram = "ejs";
    maintainers = with lib.maintainers; [ wolfangaukang ];
  };
}
