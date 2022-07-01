{ lib, callPackage, mkYarnPackage, fetchYarnDeps, fetchFromGitHub, nodejs }:

mkYarnPackage rec {
  pname = "matrix-alertmanager";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "jaywink";
    repo = pname;
    rev = "v${version}";
    sha256 = "M3/8viRCRiVJGJSHidP6nG8cr8wOl9hMFY/gzdSRN+4=";
  };

  packageJSON = ./package.json;
  yarnLock = ./yarn.lock;

  offlineCache = fetchYarnDeps {
    inherit yarnLock;
    sha256 = lib.fileContents ./yarn-hash;
  };

  prePatch = ''
    cp ${./package.json} ./package.json
  '';
  postInstall = ''
    sed '1 s;^;#!${nodejs}/bin/node\n;' -i $out/libexec/matrix-alertmanager/node_modules/matrix-alertmanager/src/app.js
    chmod +x $out/libexec/matrix-alertmanager/node_modules/matrix-alertmanager/src/app.js
  '';

  passthru.updateScript = callPackage ./update.nix {};

  meta = with lib; {
    description = "Bot to receive Alertmanager webhook events and forward them to chosen rooms";
    homepage = "https://github.com/jaywink/matrix-alertmanager";
    license = licenses.mit;
    maintainers = with maintainers; [ yuka ];
    platforms = platforms.all;
  };
}
