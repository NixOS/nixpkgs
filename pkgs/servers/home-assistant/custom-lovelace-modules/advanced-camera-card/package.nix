{
  lib,
  stdenv,
  fetchFromGitHub,
  substitute,
  dart-sass,
  yarn-berry_4,
  nodejs,
  npmHooks,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "advanced-camera-card";
  version = "8.1.0";

  src = fetchFromGitHub {
    owner = "dermotduffy";
    repo = "advanced-camera-card";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9xOUMBOogrYhICsH4iBw3eZxHaMIvkX2942UzcEV8xI=";

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

  postPatch = ''
    substituteInPlace package.json \
      --replace-fail "0.0.0-dev" "${finalAttrs.version}"
  '';

  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry_4.fetchYarnBerryDeps {
    name = "${finalAttrs.pname}-yarn-deps";
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-vqk1LCuLK3R6DgO/QWn1V96J3ZwRNeif+UAe0Bm6ndI=";
  };

  nativeBuildInputs = [
    dart-sass
    nodejs
    npmHooks.npmBuildHook
    yarn-berry_4
    yarn-berry_4.yarnBerryConfigHook
  ];

  npmBuildScript = "build";

  preBuild = ''
    substituteInPlace node_modules/sass-embedded/dist/lib/src/compiler-path.js \
      --replace-fail \
        'exports.compilerCommand = (() => {' \
        'exports.compilerCommand = (() => { return ["${lib.getExe dart-sass}"];'
  '';

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
