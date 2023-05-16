<<<<<<< HEAD
{ lib
, buildNpmPackage
, fetchFromGitHub
, jq
}:

buildNpmPackage rec {
  pname = "matrix-alertmanager";
  version = "0.7.2";
=======
{ lib, callPackage, mkYarnPackage, fetchYarnDeps, fetchFromGitHub, nodejs }:

mkYarnPackage rec {
  pname = "matrix-alertmanager";
  version = "0.5.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jaywink";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-7rsY/nUiuSVkM8fbPPa9DB3c+Uhs+Si/j1Jzls6d2qc=";
  };

  postPatch = ''
    ${lib.getExe jq} '. += {"bin": "src/app.js"}' package.json > package.json.tmp
    mv package.json.tmp package.json
  '';

  npmDepsHash = "sha256-OI/zlz03YQwUnpOiHAVQfk8PWKsurldpp0PbF1K9zbM=";

  dontNpmBuild = true;

  meta = with lib; {
    changelog = "https://github.com/jaywink/matrix-alertmanager/blob/${src.rev}/CHANGELOG.md";
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Bot to receive Alertmanager webhook events and forward them to chosen rooms";
    homepage = "https://github.com/jaywink/matrix-alertmanager";
    license = licenses.mit;
    maintainers = with maintainers; [ yuka ];
<<<<<<< HEAD
=======
    platforms = platforms.all;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
