{ lib, callPackage, mkYarnPackage, fetchYarnDeps, imagemagick }:

let
  common = callPackage ./common.nix { };
in
mkYarnPackage rec {
  src = "${common.src}/js";

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    sha256 = "sha256-VkJ6vBt9EFoQVMWMV8FhPJBHcLJDDfOxd+NLb+DZy3U=";
  };

  packageJSON = ./package.json;

  # Somehow $out/deps/mobilizon/node_modules ends up only containing nothing
  # more than a .bin directory otherwise.
  yarnPostBuild = ''
    rm -rf $out/deps/mobilizon/node_modules
    ln -s $out/node_modules $out/deps/mobilizon/node_modules
  '';

  buildPhase = ''
    runHook preBuild

    yarn run build

    runHook postBuild
  '';

  doCheck = true;
  checkPhase = "yarn run test";

  nativeBuildInputs = [ imagemagick ];

  meta = with lib; {
    description = "Frontend for the Mobilizon server";
    homepage = "https://joinmobilizon.org/";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ minijackson erictapen ];
  };
}
