{ lib
<<<<<<< HEAD
, mkYarnPackage
, fetchFromGitHub
, fetchYarnDeps
, matrix-sdk-crypto-nodejs
, makeWrapper
, nodejs
, nixosTests
}:

mkYarnPackage rec {
  pname = "mjolnir";
  version = "1.6.4";
=======
, nixosTests
, stdenv
, fetchFromGitHub
, makeWrapper
, nodejs
, pkgs
}:

stdenv.mkDerivation rec {
  pname = "mjolnir";
  version = "1.5.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "mjolnir";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-/vnojWLpu/fktqPUhAdL1QTESxDwFrBVYAkyF79Fj9w=";
  };

  packageJSON = ./package.json;

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-B4s0CYr5Ihoh4gkckwZ3z0Nb4LMET48WvRXuhk3fpQM=";
  };

  packageResolutions = {
    "@matrix-org/matrix-sdk-crypto-nodejs" = "${matrix-sdk-crypto-nodejs}/lib/node_modules/@matrix-org/matrix-sdk-crypto-nodejs";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildPhase = ''
    runHook preBuild

    pushd deps/${pname}
    yarn run build
    popd

    runHook postBuild
  '';

  postInstall = ''
    makeWrapper ${nodejs}/bin/node "$out/bin/mjolnir" \
      --add-flags "$out/libexec/mjolnir/deps/mjolnir/lib/index.js"
=======
    rev = "v${version}";
    sha256 = "YmP+r9W5e63Aw66lSQeTTbYwSF/vjPyHkoehJxtcRNw=";
  };

  nativeBuildInputs = [
    nodejs
    makeWrapper
  ];

  buildPhase =
    let
      nodeDependencies = ((import ./node-composition.nix {
        inherit pkgs nodejs;
        inherit (stdenv.hostPlatform) system;
      }).nodeDependencies.override (old: {
        # access to path '/nix/store/...-source' is forbidden in restricted mode
        src = src;
        dontNpmInstall = true;
      }));
    in
    ''
      runHook preBuild

      ln -s ${nodeDependencies}/lib/node_modules .
      export HOME=$(mktemp -d)
      export PATH="${nodeDependencies}/bin:$PATH"
      npm run build

      runHook postBuild
    '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -a . $out/share/mjolnir

    makeWrapper ${nodejs}/bin/node $out/bin/mjolnir \
      --add-flags $out/share/mjolnir/lib/index.js

    runHook postInstall
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  passthru = {
    tests = {
      inherit (nixosTests) mjolnir;
    };
<<<<<<< HEAD
=======
    updateScript = ./update.sh;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  meta = with lib; {
    description = "A moderation tool for Matrix";
    homepage = "https://github.com/matrix-org/mjolnir";
    longDescription = ''
      As an all-in-one moderation tool, it can protect your server from
      malicious invites, spam messages, and whatever else you don't want.
      In addition to server-level protection, Mjolnir is great for communities
      wanting to protect their rooms without having to use their personal
      accounts for moderation.

      The bot by default includes support for bans, redactions, anti-spam,
      server ACLs, room directory changes, room alias transfers, account
      deactivation, room shutdown, and more.

      A Synapse module is also available to apply the same rulesets the bot
      uses across an entire homeserver.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ jojosch ];
  };
}
