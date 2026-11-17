{
  lib,
  stdenv,
  fetchFromGitHub,
  substitute,
  gitMinimal,
  yarn-berry_4,
  nodejs,
  npmHooks,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "advanced-camera-card";
  version = "7.27.4";

  src = fetchFromGitHub {
    owner = "dermotduffy";
    repo = "advanced-camera-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I1dm7TZMK/eRF2Uld3e+r4PQBaL9oJc+NI+/5cxaGUs=";

    # Remove after upstream updates to Yarn 4.15
    # https://github.com/dermotduffy/advanced-camera-card/blob/main/package.json#L201
    postFetch = ''
      cd $out
      patch -p1 < ${
        (substitute {
          src = ./yarn-fix.patch;
          substitutions = [
            "--replace-fail"
            "YARN_LOCKFILE_VERSION_PLACEHOLDER"
            yarn-berry_4.lockfileVersion
          ];
        })
      }
    '';
  };

  patches = [
    # Drop hard dependency on .git repo during build
    ./gitinfo.patch
  ];

  postPatch = ''
    substituteInPlace package.json \
      --replace-fail "0.0.0-dev" "${finalAttrs.version}"
  '';

  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry_4.fetchYarnBerryDeps {
    name = "${finalAttrs.pname}-yarn-deps";
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-vbDX5TkUrNqqWLq465mLyGkQ4L8QWJtKv5aCR98P/SI=";
  };

  nativeBuildInputs = [
    gitMinimal
    nodejs
    npmHooks.npmBuildHook
    yarn-berry_4
    yarn-berry_4.yarnBerryConfigHook
  ];

  npmBuildScript = "build";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -rv dist/* $out/

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/dermotduffy/advanced-camera-card/releases/tag/${finalAttrs.src.tag}";
    description = "Comprehensive camera card for Home Assistant";
    homepage = "https://github.com/dermotduffy/advanced-camera-card";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
