{ stdenv
, lib
, fetchFromGitHub
<<<<<<< HEAD
, fetchYarnDeps
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, makeWrapper
, nodejs
, yarn
, yarn2nix-moretea
<<<<<<< HEAD
, nixosTests
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "outline";
<<<<<<< HEAD
  version = "0.71.0";
=======
  version = "0.68.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "outline";
    repo = "outline";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-vwYq5b+cMYf/gnpCwLEpErYKqYw/RwcvyBjhp+5+bTY=";
=======
    sha256 = "sha256-pln3cdozZPEodfXeUtTbBvhHb5yqE4uu0VKA95Zv6ro=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ makeWrapper yarn2nix-moretea.fixup_yarn_lock ];
  buildInputs = [ yarn nodejs ];

<<<<<<< HEAD
  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-j9iaxXfMlG9dT6fvYgPQg6Y0QvCRiBU1peO0YgsGHOY=";
  };
=======
  # Replace the inline call to yarn with our sequalize wrapper. This should be
  # the only occurrence:
  # https://github.com/outline/outline/search?l=TypeScript&q=yarn
  patches = [ ./sequelize-command.patch ];

  yarnOfflineCache = yarn2nix-moretea.importOfflineCache ./yarn.nix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    # apply upstream patches with `patch-package`
    yarn run postinstall
    yarn build

=======
    yarn build

    pushd server
    cp -r config migrations onboarding ../build/server/
    popd

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/outline
<<<<<<< HEAD
    mv build server public node_modules $out/share/outline/

    node_modules=$out/share/outline/node_modules
    build=$out/share/outline/build
    server=$out/share/outline/server
=======
    mv public node_modules build $out/share/outline/

    node_modules=$out/share/outline/node_modules
    build=$out/share/outline/build

    # On NixOS the WorkingDirectory is set to the build directory, as
    # this contains files needed in the onboarding process. This folder
    # must also contain the `public` folder for mail notifications to
    # work, as it contains the mail templates.
    ln -s $out/share/outline/public $build/public
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    makeWrapper ${nodejs}/bin/node $out/bin/outline-server \
      --add-flags $build/server/index.js \
      --set NODE_ENV production \
      --set NODE_PATH $node_modules

<<<<<<< HEAD
    runHook postInstall
  '';

  passthru.tests = {
    basic-functionality = nixosTests.outline;
  };

=======
    makeWrapper ${nodejs}/bin/node $out/bin/outline-sequelize \
      --add-flags $node_modules/.bin/sequelize \
      --add-flags "--migrations-path $build/server/migrations" \
      --add-flags "--models-path $build/server/models" \
      --add-flags "--seeders-path $build/server/models/fixtures" \
      --set NODE_ENV production \
      --set NODE_PATH $node_modules

    runHook postInstall
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "The fastest wiki and knowledge base for growing teams. Beautiful, feature rich, and markdown compatible";
    homepage = "https://www.getoutline.com/";
    changelog = "https://github.com/outline/outline/releases";
    license = licenses.bsl11;
<<<<<<< HEAD
    maintainers = with maintainers; [ cab404 yrd xanderio ];
=======
    maintainers = with maintainers; [ cab404 yrd ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.linux;
  };
}
