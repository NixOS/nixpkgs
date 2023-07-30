{ lib
, mkYarnPackage
, fetchYarnDeps
, fetchFromGitHub
, matrix-sdk-crypto-nodejs
, nixosTests
, nix-update-script
}:

mkYarnPackage rec {
  pname = "matrix-appservice-irc";
  version = "1.0.0";
  distPhase = "true";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = pname;
    rev = version;
    hash = "sha256-IlTW9OK9E7HZJVO+z2aG1z8wipwJ/FJrvmRbg2UNYX0=";
  };

  offlineCache = fetchYarnDeps {
    name = "${pname}-${version}-offline-cache";
    yarnLock = src + "/yarn.lock";
    hash = "sha256-pPZA0ckkHlbkCtgJtPgHce96nJ4PlPMLncdyNLa0ess=";
  };

  buildPhase = ''
    export HOME=$(mktemp -d)
    yarn --offline build
  '';

  postInstall = ''
    rm -rv $out/libexec/matrix-appservice-irc/node_modules/@matrix-org/matrix-sdk-crypto-nodejs
    ln -sv ${matrix-sdk-crypto-nodejs}/lib/node_modules/@matrix-org/matrix-sdk-crypto-nodejs $out/libexec/matrix-appservice-irc/node_modules/@matrix-org/
  '';

  passthru.tests.matrix-appservice-irc = nixosTests.matrix-appservice-irc;
  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Node.js IRC bridge for Matrix";
    maintainers = with maintainers; [ rhysmdnz ];
    homepage = "https://github.com/matrix-org/matrix-appservice-irc";
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
