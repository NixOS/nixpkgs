{ lib
, mkYarnPackage
, fetchFromGitHub
, makeWrapper
, nodejs
, fetchYarnDeps
,
}:
mkYarnPackage rec {
  pname = "prettierd";
  version = "0.23.4";

  src = fetchFromGitHub {
    owner = "fsouza";
    repo = "prettierd";
    rev = "v${version}";
    hash = "sha256-GTukjkA/53N9ICdfCJr5HAqhdL5T0pth6zAk8Fu/cis=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-32wMwkVgO5DQuROWnujVGNeCAUq1D6jJurecsD2ROOU=";
  };

  packageJSON = ./package.json;

  nativeBuildInputs = [ makeWrapper ];

  buildPhase = ''
    runHook preBuild
    export HOME=$(mktemp -d)
    yarn --offline build
    runHook postBuild
  '';

  # prettierd needs to be wrapped with nodejs so that it can be executed
  postInstall = ''
    wrapProgram "$out/bin/prettierd" --prefix PATH : "${nodejs}/bin"
  '';

  doDist = false;

  meta = with lib; {
    description = "Prettier, as a daemon, for improved formatting speed";
    homepage = "https://github.com/fsouza/prettierd";
    license = licenses.isc;
    changelog = "https://github.com/fsouza/prettierd/blob/${src.rev}/CHANGELOG.md";
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ NotAShelf n3oney ];
  };
}
