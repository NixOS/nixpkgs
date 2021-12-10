{ lib
, nixosTests
, fetchFromGitHub
, mkYarnPackage
}:

mkYarnPackage rec {
  pname = "ackee";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "electerious";
    repo = "Ackee";
    rev = "v${version}";
    sha256 = "l4jFBnnGazIohjpyrAcb3xL6X6wSmlKGXGmcfySf6VU=";
  };

  packageJSON = ./package.json;
  yarnLock = ./yarn.lock;
  yarnNix = ./yarn.nix;

  prePatch = ''
    sed -i '/^.*"scripts"/i "bin": { "ackee": "src/index.js" },' package.json
    chmod +x src/index.js
  '';

  preBuild = ''
    yarn build
  '';

  passthru.tests = { inherit (nixosTests) ackee; };

  meta = with lib; {
    description = "Self-hosted, Node.js based analytics tool for those who care about privacy";
    license = licenses.mit;
    homepage = "https://ackee.electerious.com";
    maintainers = with maintainers; [ Flakebi ];
    platforms = platforms.linux;
  };
}
