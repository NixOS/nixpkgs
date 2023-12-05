{ yarn2nix-moretea
, fetchFromGitHub
, fetchYarnDeps
, meta
}:

yarn2nix-moretea.mkYarnPackage rec {
  pname = "listmonk-frontend";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "knadh";
    repo = "listmonk";
    rev = "v${version}";
    sha256 = "sha256-gCnIblc83CmG1auvYYxqW/xBl6Oy1KHGkqSY/3yIm3I=";
  };

  packageJSON = ./package.json;
  yarnLock = "${src}/frontend/yarn.lock";

  offlineCache = fetchYarnDeps {
    inherit yarnLock;
    hash = "sha256-KKNk4lrM7unMFClkY6F3nqhKx5xfx87Ac+rug9sOwvI=";
  };

  # For Node.js v17+, this is necessary.
  NODE_OPTIONS = "--openssl-legacy-provider";

  installPhase = ''
    runHook preInstall

    cd deps/listmonk-frontend/frontend
    npm run build

    mv dist $out

    runHook postInstall
  '';

  doDist = false;


  inherit meta;
}
