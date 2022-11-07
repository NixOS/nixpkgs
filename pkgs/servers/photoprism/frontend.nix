{ lib, nodePackages, nodejs-14_x, stdenv, src, version, ... }:

let
  nodeDependencies = nodePackages.photoprism-frontend.override {
    inherit version;
    name = "photoprism-frontend-dependencies";

    # Workaround for lack of sourceRoot option in buildNodePackage.
    src = "${src}/frontend";

    meta.broken = false;
  };
in
stdenv.mkDerivation {
  inherit src version;
  pname = "photoprism-frontend";

  buildInputs = [ nodejs-14_x ];

  buildPhase = ''
    runHook preBuild

    pushd frontend
    ln -s ${nodeDependencies}/lib/node_modules/photoprism/node_modules ./node_modules
    export PATH="${nodeDependencies}/lib/node_modules/photoprism/node_modules/.bin:$PATH"
    NODE_ENV=production npm run build
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r assets $out/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://photoprism.app";
    description = "Photoprism's frontend";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ benesim ];
  };
}
