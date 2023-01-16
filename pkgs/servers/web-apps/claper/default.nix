{ lib
, stdenv
, beamPackages
, fetchFromGitHub
, mkYarnModules
, glibcLocales
, cacert
, nodejs
, nixosTests
}:

let
  pname = "claper";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "claperco";
    repo = "claper";
    rev = "v${version}";
    sha256 = "Urtfz7Dzy0Ws9wm6qZgrvD5OMmFFECs88Q+LoQEHD/c=";
  };

  mixFodDeps = beamPackages.fetchMixDeps {
    pname = "${pname}-deps";
    inherit src version;
    sha256 = "U104ytDxNUoQjyCYXfgsczSq9xx5EQ7qYUOkmBcc9/k=";
  };

  yarnDeps = mkYarnModules {
    pname = "${pname}-yarn-deps";
    inherit version;
    packageJSON = ./package.json;
    yarnLock = ./yarn.lock;
  };
in
beamPackages.mixRelease {
  inherit pname version src mixFodDeps;

  nativeBuildInputs = [ nodejs ];

  postBuild = ''
    # required for webpack compatibility with OpenSSL 3 (https://github.com/webpack/webpack/issues/14532)
    export NODE_OPTIONS=--openssl-legacy-provider
    ln -sf ${yarnDeps}/node_modules assets/node_modules
  '';

  meta = with lib; {
    license = licenses.gpl3Only;
    homepage = "https://claper.co/";
    description = "The ultimate tool to interact with your audience";
    maintainers = with maintainers; [ drupol ];
    platforms = platforms.unix;
  };
}
