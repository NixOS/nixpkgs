{
  lib,
  buildNpmPackage,
  stdenv,
  chromium,
  ffmpeg,
  jq,
  nodejs,
  fetchFromGitHub,
  linkFarm,
  callPackage,
  makeFontsConf,
  makeWrapper,
  runCommand,
  cacert,
}:
let
  inherit (stdenv.hostPlatform) system;

  throwSystem = throw "Unsupported system: ${system}";
  suffix =
    {
      x86_64-linux = "linux";
      aarch64-linux = "linux-arm64";
      x86_64-darwin = "mac";
      aarch64-darwin = "mac-arm64";
    }
    .${system} or throwSystem;

  version = "1.47.0";

  src = fetchFromGitHub {
    owner = "Microsoft";
    repo = "playwright";
    rev = "v${version}";
    hash = "sha256-cKjVDy1wFo8NlF8v+8YBuQUF2OUYjCmv27uhEoVUrno=";
  };

  babel-bundle = buildNpmPackage {
    pname = "babel-bundle";
    inherit version src;
    sourceRoot = "${src.name}/packages/playwright/bundles/babel";
    npmDepsHash = "sha256-HrDTkP2lHl2XKD8aGpmnf6YtSe/w9UePH5W9QfbaoMg=";
    dontNpmBuild = true;
    installPhase = ''
      cp -r . "$out"
    '';
  };
  expect-bundle = buildNpmPackage {
    pname = "expect-bundle";
    inherit version src;
    sourceRoot = "${src.name}/packages/playwright/bundles/expect";
    npmDepsHash = "sha256-qnFx/AQZtmxNFrrabfOpsWy6I64DFJf3sWrJzL1wfU4=";
    dontNpmBuild = true;
    installPhase = ''
      cp -r . "$out"
    '';
  };
  utils-bundle = buildNpmPackage {
    pname = "utils-bundle";
    inherit version src;
    sourceRoot = "${src.name}/packages/playwright/bundles/utils";
    npmDepsHash = "sha256-d+nE11x/493BexI70mVbnZFLQClU88sscbNwruXjx1M=";
    dontNpmBuild = true;
    installPhase = ''
      cp -r . "$out"
    '';
  };
  utils-bundle-core = buildNpmPackage {
    pname = "utils-bundle-core";
    inherit version src;
    sourceRoot = "${src.name}/packages/playwright-core/bundles/utils";
    npmDepsHash = "sha256-aktxEDQKxsDcInyjDKDuIu4zwtrAH0lRda/mP1IayPA=";
    dontNpmBuild = true;
    installPhase = ''
      cp -r . "$out"
    '';
  };
  zip-bundle = buildNpmPackage {
    pname = "zip-bundle";
    inherit version src;
    sourceRoot = "${src.name}/packages/playwright-core/bundles/zip";
    npmDepsHash = "sha256-62Apz8uX6d4HKDqQxR6w5Vs31tl63McWGPwT6s2YsBE=";
    dontNpmBuild = true;
    installPhase = ''
      cp -r . "$out"
    '';
  };

  playwright = buildNpmPackage {
    pname = "playwright";
    inherit version src;

    sourceRoot = "${src.name}"; # update.sh depends on sourceRoot presence
    npmDepsHash = "sha256-FaDTJmIiaaOCvq6tARfiWX5IBTTNOJ/iVkRsO4D8aqc=";

    nativeBuildInputs = [ cacert ];

    ELECTRON_SKIP_BINARY_DOWNLOAD = true;

    postPatch = ''
      sed -i '/\/\/ Update test runner./,/^\s*$/{d}' utils/build/build.js
      sed -i '/\/\/ Update bundles./,/^\s*$/{d}' utils/build/build.js
      sed -i '/execSync/d' ./utils/generate_third_party_notice.js
      sed -i '/plugins: /d' ./packages/playwright/bundles/utils/build.js
      sed -i '/plugins: /d' ./packages/playwright-core/bundles/zip/build.js
      chmod +w packages/playwright/bundles/babel
      ln -s ${babel-bundle}/node_modules packages/playwright/bundles/babel/node_modules
      chmod +w packages/playwright/bundles/expect
      ln -s ${expect-bundle}/node_modules packages/playwright/bundles/expect/node_modules
      chmod +w packages/playwright/bundles/utils
      ln -s ${utils-bundle}/node_modules packages/playwright/bundles/utils/node_modules
      chmod +w packages/playwright-core/bundles/utils
      ln -s ${utils-bundle-core}/node_modules packages/playwright-core/bundles/utils/node_modules
      chmod +w packages/playwright-core/bundles/zip
      ln -s ${zip-bundle}/node_modules packages/playwright-core/bundles/zip/node_modules
    '';

    installPhase = ''
      runHook preInstall

      shopt -s extglob

      mkdir -p "$out/lib"
      cp -r packages/playwright/node_modules "$out/lib/node_modules"

      mkdir -p "$out/lib/node_modules/playwright"
      cp -r packages/playwright/!(bundles|src|node_modules|.*) "$out/lib/node_modules/playwright"

      mkdir -p "$out/lib/node_modules/playwright-core"
      cp -r packages/playwright-core/!(bundles|src|bin|.*) "$out/lib/node_modules/playwright-core"

      mkdir -p "$out/lib/node_modules/@playwright/test"
      cp -r packages/playwright-test/* "$out/lib/node_modules/@playwright/test"

      runHook postInstall
    '';

    meta = {
      description = "Framework for Web Testing and Automation";
      homepage = "https://playwright.dev";
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [ kalekseev ];
      inherit (nodejs.meta) platforms;
    };
  };

  playwright-core = stdenv.mkDerivation (finalAttrs: {
    pname = "playwright-core";
    inherit (playwright) version src meta;

    installPhase = ''
      runHook preInstall

      cp -r ${playwright}/lib/node_modules/playwright-core "$out"

      runHook postInstall
    '';

    passthru = {
      browsersJSON = (lib.importJSON ./browsers.json).browsers;
      browsers =
        {
          x86_64-linux = browsers-linux { };
          aarch64-linux = browsers-linux { };
          x86_64-darwin = browsers-mac;
          aarch64-darwin = browsers-mac;
        }
        .${system} or throwSystem;
      browsers-chromium = browsers-linux { };
    };
  });

  playwright-test = stdenv.mkDerivation (finalAttrs: {
    pname = "playwright-test";
    inherit (playwright) version src;

    nativeBuildInputs = [ makeWrapper ];
    installPhase = ''
      runHook preInstall

      shopt -s extglob
      mkdir -p $out/bin
      cp -r ${playwright}/* $out

      makeWrapper "${nodejs}/bin/node" "$out/bin/playwright" \
        --add-flags "$out/lib/node_modules/@playwright/test/cli.js" \
        --prefix NODE_PATH : ${placeholder "out"}/lib/node_modules \
        --set-default PLAYWRIGHT_BROWSERS_PATH "${playwright-core.passthru.browsers}"

      runHook postInstall
    '';

    meta = playwright.meta // {
      mainProgram = "playwright";
    };
  });

  browsers-mac = stdenv.mkDerivation {
    pname = "playwright-browsers";
    inherit (playwright) version;

    dontUnpack = true;

    nativeBuildInputs = [ cacert ];

    installPhase = ''
      runHook preInstall

      export PLAYWRIGHT_BROWSERS_PATH=$out
      ${playwright-core}/cli.js install
      rm -r $out/.links

      runHook postInstall
    '';

    meta.platforms = lib.platforms.darwin;
  };

  browsers-linux = lib.makeOverridable (
    {
      withChromium ? true,
      withFirefox ? true,
      withWebkit ? true,
      withFfmpeg ? true,
      fontconfig_file ? makeFontsConf {
        fontDirectories = [ ];
      },
    }:
    let
      browsers =
        lib.optionals withChromium [ "chromium" ]
        ++ lib.optionals withFirefox [ "firefox" ]
        ++ lib.optionals withWebkit [ "webkit" ]
        ++ lib.optionals withFfmpeg [ "ffmpeg" ];
    in
    linkFarm "playwright-browsers" (
      lib.listToAttrs (
        map (
          name:
          let
            value = playwright-core.passthru.browsersJSON.${name};
          in
          lib.nameValuePair
            # TODO check platform for revisionOverrides
            "${name}-${value.revision}"
            (
              callPackage ./${name}.nix (
                {
                  inherit suffix system throwSystem;
                  inherit (value) revision;
                }
                // lib.optionalAttrs (name == "chromium") {
                  inherit fontconfig_file;
                }
              )
            )
        ) browsers
      )
    )
  );
in
{
  playwright-core = playwright-core;
  playwright-test = playwright-test;
}
