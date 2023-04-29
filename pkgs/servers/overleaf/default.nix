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
, callPackage
}:

let
  pname = "overleaf";
  version = "3.5";

  deps = stdenv.mkDerivation {
    name = "${pname}-${version}-deps";

    src = fetchFromGitHub {
      owner = "overleaf";
      repo = "overleaf";
      rev = "d539aaf2262149361590514fe27fd5c8e0fab111";
      hash = "sha256-HuK9s7040sH9lBHb6yGO+fll2hrpdTIGIYIUujVkhqw=";
    };

    patches = [ ./versions.patch ];

    postPatch = ''
      # Add the custom yarn.lock
      rm package-lock.json
      cp ${./yarn.lock} yarn.lock
      chmod +rw yarn.lock
      cp ${./package.json} package.json

      # Replace hard-coded values in settings by environment variables
      find . -type f -not -path '*/\.*' -exec sed -E -i "s|SHARELATEX_|OVERLEAF_|g" {} +
      (
        cd server-ce/config
        sed -E -i "s!'dockerhost',!undefined,\n      path: process.env.OVERLEAF_REDIS_PATH || undefined,!" ./settings.js
        sed -E -i "s!'6379'!undefined!" ./settings.js
        sed -E -i "s|httpAuthUser = 'sharelatex'|httpAuthUser = process.env.WEB_API_USER|" ./settings.js
        sed -E -i "s|'/var/lib/sharelatex(.*)'|\`\''${process.env.DATA_DIR}\1\`|" ./settings.js
        sed -E -i "s!'http://localhost:3000'!\`http://\''${process.env.WEB_API_HOST || process.env.WEB_HOST || 'localhost'}:\''${process.env.WEB_API_PORT || process.env.WEB_PORT || 3000}\`!" ./settings.js
      )
    '';

    buildInputs = [ pkgs.jq python3 fixup_yarn_lock nodejs-16_x nodejs-16_x.pkgs.node-pre-gyp nodejs-16_x.pkgs.node-gyp yarn ];

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
      (
        cd node_modules/diskusage
        export CPPFLAGS="-I${nodejs-16_x}/include/node"
        node-gyp configure --nodedir=${nodejs-16_x}/include/node
        node-gyp build --nodedir=${nodejs-16_x}/include/node
      )
      patchShebangs node_modules
    '';

    installPhase = ''
      mkdir $out
      cp -r . $out
    '';
  };
in

stdenv.mkDerivation {
  pname = "overleaf";
  version = "3.5";
  src = deps;
  buildInputs = [ nodejs-16_x makeWrapper ];

  buildPhase = ''
    (
      cd services/web
      npm run webpack:production
    )
  '';

  installPhase = ''
    mkdir -p $out/{share,bin}
    cp -r . $out/share
    ln -s ${callPackage ./gitbridge.nix {}}/bin/overleaf-gitbridge $out/bin/overleaf-gitbridge
  '';

  postFixup = ''
    makeWrapper ${nodejs-16_x}/bin/node $out/bin/overleaf-chat \
      --add-flags app.js \
      --chdir $out/share/services/chat

    makeWrapper ${nodejs-16_x}/bin/node $out/bin/overleaf-clsi \
      --add-flags app.js \
      --chdir $out/share/services/clsi

    makeWrapper ${nodejs-16_x}/bin/node $out/bin/overleaf-contacts \
      --add-flags app.js \
      --chdir $out/share/services/contacts

    makeWrapper ${nodejs-16_x}/bin/node $out/bin/overleaf-docstore \
      --add-flags app.js \
      --chdir $out/share/services/docstore

    makeWrapper ${nodejs-16_x}/bin/node $out/bin/overleaf-document-updater \
      --add-flags app.js \
      --chdir $out/share/services/document-updater

    makeWrapper ${nodejs-16_x}/bin/node $out/bin/overleaf-filestore \
      --add-flags app.js \
      --chdir $out/share/services/filestore

    makeWrapper ${nodejs-16_x}/bin/node $out/bin/overleaf-history-v1 \
      --add-flags app.js \
      --chdir $out/share/services/history-v1

    makeWrapper ${nodejs-16_x}/bin/node $out/bin/overleaf-notifications \
      --add-flags app.js \
      --chdir $out/share/services/notifications

    makeWrapper ${nodejs-16_x}/bin/node $out/bin/overleaf-project-history \
      --add-flags app.js \
      --chdir $out/share/services/project-history

    makeWrapper ${nodejs-16_x}/bin/node $out/bin/overleaf-real-time \
      --add-flags app.js \
      --chdir $out/share/services/real-time

    makeWrapper ${nodejs-16_x}/bin/node $out/bin/overleaf-spelling \
      --add-flags app.js \
      --chdir $out/share/services/spelling

    makeWrapper ${nodejs-16_x}/bin/node $out/bin/overleaf-track-changes \
      --add-flags app.js \
      --chdir $out/share/services/track-changes

    makeWrapper ${nodejs-16_x}/bin/node $out/bin/overleaf-web \
      --add-flags app.js \
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

