{
  lib,
  mkYarnPackage,
  fetchFromGitHub,
  fetchYarnDeps,
  matrix-sdk-crypto-nodejs,
  makeWrapper,
  nodejs,
  nixosTests,
}:

mkYarnPackage rec {
  pname = "mjolnir";
  version = "1.6.5";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "mjolnir";
    rev = "refs/tags/v${version}";
    hash = "sha256-xejFKz2MmdjMFU0X0SdI+qXTBRAwIvkcfZPQqXB9LV0=";
  };

  packageJSON = ./package.json;

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-RpvdyxJj92k4wFjBBmWCnEpFVOXVWlHEm0SmEBUlnTM=";
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
  '';

  passthru = {
    tests = {
      inherit (nixosTests) mjolnir;
    };
  };

  meta = with lib; {
    description = "Moderation tool for Matrix";
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
    mainProgram = "mjolnir";
  };
}
