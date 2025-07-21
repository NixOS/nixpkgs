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

  version = "1.53.1";

  src = fetchFromGitHub {
    owner = "Microsoft";
    repo = "playwright";
    rev = "v${version}";
    hash = "sha256-N5BS8zpoQGUf5gly0fyutaK76CAhbwOGAUofGnfkmnM=";
  };

  babel-bundle = buildNpmPackage {
    pname = "babel-bundle";
    inherit version src;
    sourceRoot = "${src.name}/packages/playwright/bundles/babel";
    npmDepsHash = "sha256-sdl+rMCmuOmY1f7oSfGuAAFCiPCFzqkQtFCncL4o5LQ=";
    dontNpmBuild = true;
    installPhase = ''
      cp -r . "$out"
    '';
  };
  expect-bundle = buildNpmPackage {
    pname = "expect-bundle";
    inherit version src;
    sourceRoot = "${src.name}/packages/playwright/bundles/expect";
    npmDepsHash = "sha256-KwxNqPefvPPHG4vbco2O4G8WlA7l33toJdfNWHMTDOQ=";
    dontNpmBuild = true;
    installPhase = ''
      cp -r . "$out"
    '';
  };
  utils-bundle = buildNpmPackage {
    pname = "utils-bundle";
    inherit version src;
    sourceRoot = "${src.name}/packages/playwright/bundles/utils";
    npmDepsHash = "sha256-InwWYRk6eRF62qI6qpVaPceIetSr3kPIBK4LdfeoJdo=";
    dontNpmBuild = true;
    installPhase = ''
      cp -r . "$out"
    '';
  };
  utils-bundle-core = buildNpmPackage {
    pname = "utils-bundle-core";
    inherit version src;
    sourceRoot = "${src.name}/packages/playwright-core/bundles/utils";
    npmDepsHash = "sha256-3hdOmvs/IGAgW7vhldms9Q9/ZQfbjbc+xP+JEtGJ7g8=";
    dontNpmBuild = true;
    installPhase = ''
      cp -r . "$out"
    '';
  };
  zip-bundle = buildNpmPackage {
    pname = "zip-bundle";
    inherit version src;
    sourceRoot = "${src.name}/packages/playwright-core/bundles/zip";
    npmDepsHash = "sha256-c0UZ0Jg86icwJp3xarpXpxWjRYeIjz9wpWtJZDHkd8U=";
    dontNpmBuild = true;
    installPhase = ''
      cp -r . "$out"
    '';
  };

  playwright = buildNpmPackage {
    pname = "playwright";
    inherit version src;

    sourceRoot = "${src.name}"; # update.sh depends on sourceRoot presence
    npmDepsHash = "sha256-a1s1l8PG0ViVqYOksB2dkID/AHczMjLNQJW88+yB0B0=";

    nativeBuildInputs = [
      cacert
      jq
    ];

    ELECTRON_SKIP_BINARY_DOWNLOAD = true;

    postPatch = ''
      sed -i '/\/\/ Update test runner./,/^\s*$/{d}' utils/build/build.js
      sed -i '/^\/\/ Update bundles\./,/^[[:space:]]*}$/d' utils/build/build.js
      sed -i '/execSync/d' ./utils/generate_third_party_notice.js
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

      # for not supported platforms (such as NixOS) playwright assumes that it runs on ubuntu-20.04
      # that forces it to use overridden webkit revision
      # let's remove that override to make it use latest revision provided in Nixpkgs
      # https://github.com/microsoft/playwright/blob/baeb065e9ea84502f347129a0b896a85d2a8dada/packages/playwright-core/src/server/utils/hostPlatform.ts#L111
      jq '(.browsers[] | select(.name == "webkit") | .revisionOverrides) |= del(."ubuntu20.04-x64", ."ubuntu20.04-arm64")' \
        packages/playwright-core/browsers.json > browser.json.tmp && mv browser.json.tmp packages/playwright-core/browsers.json
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
      maintainers = with lib.maintainers; [
        kalekseev
        marie
      ];
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
      browsers = browsers { };
      browsers-chromium = browsers {
        withFirefox = false;
        withWebkit = false;
        withChromiumHeadlessShell = false;
      };
      inherit components;
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

  components = {
    chromium = callPackage ./chromium.nix {
      inherit suffix system throwSystem;
      inherit (playwright-core.passthru.browsersJSON.chromium) revision;
      fontconfig_file = makeFontsConf {
        fontDirectories = [ ];
      };
    };
    chromium-headless-shell = callPackage ./chromium-headless-shell.nix {
      inherit suffix system throwSystem;
      inherit (playwright-core.passthru.browsersJSON.chromium) revision;
    };
    firefox = callPackage ./firefox.nix {
      inherit suffix system throwSystem;
      inherit (playwright-core.passthru.browsersJSON.firefox) revision;
    };
    webkit = callPackage ./webkit.nix {
      inherit suffix system throwSystem;
      inherit (playwright-core.passthru.browsersJSON.webkit) revision;
    };
    ffmpeg = callPackage ./ffmpeg.nix {
      inherit suffix system throwSystem;
      inherit (playwright-core.passthru.browsersJSON.ffmpeg) revision;
    };
  };

  browsers = lib.makeOverridable (
    {
      withChromium ? true,
      withFirefox ? true,
      withWebkit ? true, # may require `export PLAYWRIGHT_HOST_PLATFORM_OVERRIDE="ubuntu-24.04"`
      withFfmpeg ? true,
      withChromiumHeadlessShell ? true,
      fontconfig_file ? makeFontsConf {
        fontDirectories = [ ];
      },
    }:
    let
      browsers =
        lib.optionals withChromium [ "chromium" ]
        ++ lib.optionals withChromiumHeadlessShell [ "chromium-headless-shell" ]
        ++ lib.optionals withFirefox [ "firefox" ]
        ++ lib.optionals withWebkit [ "webkit" ]
        ++ lib.optionals withFfmpeg [ "ffmpeg" ];
    in
    linkFarm "playwright-browsers" (
      lib.listToAttrs (
        map (
          name:
          let
            revName = if name == "chromium-headless-shell" then "chromium" else name;
            value = playwright-core.passthru.browsersJSON.${revName};
          in
          lib.nameValuePair
            # TODO check platform for revisionOverrides
            "${lib.replaceStrings [ "-" ] [ "_" ] name}-${value.revision}"
            components.${name}
        ) browsers
      )
    )
  );
in
{
  playwright-core = playwright-core;
  playwright-test = playwright-test;
}
