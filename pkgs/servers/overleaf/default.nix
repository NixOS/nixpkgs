{ pkgs
, lib
, stdenv
, fetchFromGitHub
, makeWrapper
, python3
, fetchYarnDeps
, fixup_yarn_lock
, nodejs-16_x
, yarn
}:

stdenv.mkDerivation rec {
  pname = "overleaf";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "overleaf";
    repo = "overleaf";
    rev = "d539aaf2262149361590514fe27fd5c8e0fab111";
    hash = "sha256-HuK9s7040sH9lBHb6yGO+fll2hrpdTIGIYIUujVkhqw=";
  };

  patches = [ ./versions.patch ];

  postPatch = ''
    rm package-lock.json
    cp ${./yarn.lock} yarn.lock
    chmod +rw yarn.lock
    cp ${./package.json} package.json
  '';

  buildInputs = [ python3 fixup_yarn_lock nodejs-16_x nodejs-16_x.pkgs.node-pre-gyp yarn makeWrapper ];

  offlineCache = fetchYarnDeps {
    yarnLock = ./yarn.lock;
    sha256 = "sha256-ci68170df9o3fJuw8AH/qdJR8NZ2o9OeAg8gfjycHd0=";
  };

  buildPhase = ''
    runHook preBuild
    export HOME=$PWD
    export NODE_OPTIONS=--openssl-legacy-provider
    fixup_yarn_lock yarn.lock
    yarn config --offline set yarn-offline-mirror $offlineCache
    yarn --offline --frozen-lockfile --ignore-scripts --ignore-engines
    (
      cd node_modules/bcrypt
      export CPPFLAGS="-I${nodejs-16_x}/include/node"
      node-pre-gyp install --prefer-offline --build-from-source --nodedir=${nodejs-16_x}/include/node
    )
    patchShebangs node_modules
    (
      cd services/web
      npm run webpack:production
    )
    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out/share
    cp -r . $out/share
  '';

  postFixup = ''
    makeWrapper ${nodejs-16_x}/bin/npm $out/bin/overleaf-chat \
      --add-flags start \
      --chdir $out/share/services/chat

    makeWrapper ${nodejs-16_x}/bin/npm $out/bin/overleaf-clsi \
      --add-flags start \
      --chdir $out/share/services/clsi

    makeWrapper ${nodejs-16_x}/bin/npm $out/bin/overleaf-contacts \
      --add-flags start \
      --chdir $out/share/services/contacts

    makeWrapper ${nodejs-16_x}/bin/npm $out/bin/overleaf-docstore \
      --add-flags start \
      --chdir $out/share/services/docstore

    makeWrapper ${nodejs-16_x}/bin/npm $out/bin/overleaf-document-updater \
      --add-flags start \
      --chdir $out/share/services/document-updater

    makeWrapper ${nodejs-16_x}/bin/npm $out/bin/overleaf-filestore \
      --add-flags start \
      --chdir $out/share/services/filestore

    makeWrapper ${nodejs-16_x}/bin/npm $out/bin/overleaf-history-v1 \
      --add-flags start \
      --chdir $out/share/services/history-v1

    makeWrapper ${nodejs-16_x}/bin/npm $out/bin/overleaf-notifications \
      --add-flags start \
      --chdir $out/share/services/notifications

    makeWrapper ${nodejs-16_x}/bin/npm $out/bin/project-history \
      --add-flags start \
      --chdir $out/share/services/project-history

    makeWrapper ${nodejs-16_x}/bin/npm $out/bin/overleaf-real-time \
      --add-flags start \
      --chdir $out/share/services/real-time

    makeWrapper ${nodejs-16_x}/bin/npm $out/bin/overleaf-spelling \
      --add-flags start \
      --chdir $out/share/services/spelling

    makeWrapper ${nodejs-16_x}/bin/npm $out/bin/overleaf-track-changes \
      --add-flags start \
      --chdir $out/share/services/track-changes

    makeWrapper ${nodejs-16_x}/bin/npm $out/bin/overleaf-web \
      --add-flags start \
      --chdir $out/share/services/web
  '';

  meta = with lib; {
    description = "A web-based collaborative LaTeX editor";
    homepage = "https://github.com/overleaf/overleaf";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ camillemndn julienmalka ];
    platforms = platforms.all;
  };
}

