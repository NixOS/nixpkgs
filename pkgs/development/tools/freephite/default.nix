{
  bun,
  fetchFromGitHub,
  fetchYarnDeps,
  lib,
  mkYarnPackage
}:

mkYarnPackage rec {
  pname = "freephite";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "bradymadden97";
    repo = "freephite";
    rev = "v${version}";
    hash = "sha256-oTZVjslZwZF7XVHX39+7iBHJvasFS2/U8YKSD6RWhEI=";
  };

  extraBuildInputs = [
    bun
  ];

  preBuild = ''
    yarn build
    chmod +x deps/@bradymadden97/freephite-cli/dist/src/index.js
  '';

  yarnLock = ./yarn.lock;

  offlineCache = fetchYarnDeps {
    yarnLock = ./yarn.lock;
    hash = "sha256-ujASwix5uMMw7OtKlPgzewAyDU/VueXFkLVDAG7bDdY=";
  };

  doDist = false;

  meta = with lib; {
    description = "Forked version of Graphite, keeping the OSS license.";
    homepage = "https://github.com/@bradymadden97/freephite";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      cdmistman
    ];
  };
}
