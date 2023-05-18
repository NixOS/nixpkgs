{ yarn2nix-moretea
, fetchFromGitHub
, meta
}:

yarn2nix-moretea.mkYarnPackage rec {
  pname = "listmonk-frontend";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "knadh";
    repo = "listmonk";
    rev = "v${version}";
    sha256 = "sha256-dtIM0dkr8y+GbyCqrBlR5VRq6qMiZdmQyFvIoVY1eUg=";
  };

  packageJSON = ./package.json;
  yarnLock = ./yarn.lock;
  yarnNix = ./yarn.nix;

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
