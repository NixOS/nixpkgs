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
  version = "0.68.1";

  src = fetchFromGitHub {
    owner = "outline";
    repo = "outline";
    rev = "v${version}";
    sha256 = "sha256-pln3cdozZPEodfXeUtTbBvhHb5yqE4uu0VKA95Zv6ro=";
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
    mv public node_modules build $out/share/outline/

    node_modules=$out/share/outline/node_modules
    build=$out/share/outline/build

    # On NixOS the WorkingDirectory is set to the build directory, as
    # this contains files needed in the onboarding process. This folder
    # must also contain the `public` folder for mail notifications to
    # work, as it contains the mail templates.
    ln -s $out/share/outline/public $build/public

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
