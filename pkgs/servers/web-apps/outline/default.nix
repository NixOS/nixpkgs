{ stdenv
, lib
, fetchFromGitHub
, makeWrapper
, nodejs
, yarn
, yarn2nix-moretea
}:

stdenv.mkDerivation rec {
  pname = "outline";
  version = "0.66.2";

  src = fetchFromGitHub {
    owner = "outline";
    repo = "outline";
    rev = "v${version}";
    sha256 = "sha256-jRnw6UIUA3gAgyqQg6R1GOI4O8HXKnVfTH3d3SFBa9A=";
  };

  nativeBuildInputs = [ makeWrapper yarn2nix-moretea.fixup_yarn_lock ];
  buildInputs = [ yarn nodejs ];

  # Replace the inline call to yarn with our sequalize wrapper. This should be
  # the only occurrence:
  # https://github.com/outline/outline/search?l=TypeScript&q=yarn
  patches = [ ./sequelize-command.patch ];

  yarnOfflineCache = yarn2nix-moretea.importOfflineCache ./yarn.nix;

  configurePhase = ''
    export HOME=$(mktemp -d)/yarn_home
  '';

  buildPhase = ''
    runHook preBuild
    export NODE_OPTIONS=--openssl-legacy-provider

    yarn config --offline set yarn-offline-mirror $yarnOfflineCache
    fixup_yarn_lock yarn.lock

    yarn install --offline \
      --frozen-lockfile \
      --ignore-engines --ignore-scripts
    patchShebangs node_modules/
    yarn build

    pushd server
    cp -r config migrations onboarding ../build/server/
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/outline
    mv node_modules build $out/share/outline/

    node_modules=$out/share/outline/node_modules
    build=$out/share/outline/build

    makeWrapper ${nodejs}/bin/node $out/bin/outline-server \
      --add-flags $build/server/index.js \
      --set NODE_ENV production \
      --set NODE_PATH $node_modules

    makeWrapper ${nodejs}/bin/node $out/bin/outline-sequelize \
      --add-flags $node_modules/.bin/sequelize \
      --add-flags "--migrations-path $build/server/migrations" \
      --add-flags "--models-path $build/server/models" \
      --add-flags "--seeders-path $build/server/models/fixtures" \
      --set NODE_ENV production \
      --set NODE_PATH $node_modules

    runHook postInstall
  '';

  meta = with lib; {
    description = "The fastest wiki and knowledge base for growing teams. Beautiful, feature rich, and markdown compatible";
    homepage = "https://www.getoutline.com/";
    changelog = "https://github.com/outline/outline/releases";
    license = licenses.bsl11;
    maintainers = with maintainers; [ cab404 yrd ];
    platforms = platforms.linux;
  };
}
