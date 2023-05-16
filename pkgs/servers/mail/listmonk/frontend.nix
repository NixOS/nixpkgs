{ yarn2nix-moretea
, fetchFromGitHub
<<<<<<< HEAD
, fetchYarnDeps
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, meta
}:

yarn2nix-moretea.mkYarnPackage rec {
  pname = "listmonk-frontend";
<<<<<<< HEAD
  version = "2.5.1";
=======
  version = "2.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "knadh";
    repo = "listmonk";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-gCnIblc83CmG1auvYYxqW/xBl6Oy1KHGkqSY/3yIm3I=";
  };

  packageJSON = ./package.json;
  yarnLock = "${src}/frontend/yarn.lock";

  offlineCache = fetchYarnDeps {
    inherit yarnLock;
    hash = "sha256-KKNk4lrM7unMFClkY6F3nqhKx5xfx87Ac+rug9sOwvI=";
  };
=======
    sha256 = "sha256-dtIM0dkr8y+GbyCqrBlR5VRq6qMiZdmQyFvIoVY1eUg=";
  };

  packageJSON = ./package.json;
  yarnLock = ./yarn.lock;
  yarnNix = ./yarn.nix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
