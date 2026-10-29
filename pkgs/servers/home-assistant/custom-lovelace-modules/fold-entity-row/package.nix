{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

buildNpmPackage (finalAttrs: {
  pname = "fold-entity-row";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "thomasloven";
    repo = "lovelace-fold-entity-row";
    tag = "v.${finalAttrs.version}";
    hash = "sha256-pbH2XNVrZEq3U9Kugq0X5U/CT9LNaWP9su4qWk6oob0=";
  };

  patches = [ ./add-babel-core-dependency.patch ];

  npmDepsFetcherVersion = 2;
  npmFlags = [ "--legacy-peer-deps" ];
  npmDepsHash = "sha256-/pm5K088cOa1M/NqlOJ7RtrxKik95Me/d68yzem9ktI=";

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp fold-entity-row.js $out

    runHook postInstall
  '';

  meta = {
    description = "Fold away and hide rows in lovelace entities cards.";
    homepage = "https://github.com/thomasloven/lovelace-fold-entity-row";
    changelog = "https://github.com/thomasloven/lovelace-fold-entity-row/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rhoriguchi ];
    platforms = lib.platforms.all;
  };
})
