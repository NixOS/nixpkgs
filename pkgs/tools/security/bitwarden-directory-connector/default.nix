{
  lib,
  buildNpmPackage,
  cargo,
  electron,
  fetchFromGitHub,
  libsecret,
  nodejs_24,
  pkg-config,
  python3,
  rustc,
  rustPlatform,
}:

let
  common =
    {
      name,
      npmBuildScript,
      installPhase,
    }:
    buildNpmPackage (finalAttrs: {
      pname = name;
      version = "2026.6.1";
      nodejs = nodejs_24;

      src = fetchFromGitHub {
        owner = "bitwarden";
        repo = "directory-connector";
        tag = "v${finalAttrs.version}";
        hash = "sha256-4u1RwZfjjdwK8mPb7jV4Vg22CqjcHBwX+CXdQDHCVFw=";
      };

      patches = [
        ./lockfile-add-resolved.patch
      ];

      postPatch = ''
        substituteInPlace package.json \
          --replace-fail '"preinstall": "npm run sub:init",' "" \
          --replace-fail "cd native && npm install && npm run build:release" "cd native && npm run build:release"

        substituteInPlace electron-builder.json \
          --replace-fail '"afterSign": "scripts/notarize.mjs",' ""
      '';

      npmDepsFetcherVersion = 2;
      npmDepsHash = "sha256-1Yu/drKTE6GgFetnJpQSOiTHCUK2XN3KGFGEXeu5vKA=";

      cargoRoot = "native";
      cargoDeps = rustPlatform.fetchCargoVendor {
        inherit (finalAttrs)
          pname
          src
          version
          cargoRoot
          ;
        hash = "sha256-1YcdUuAAIFevZJg4dY9xEBw0TLsUFoMGoMW7ZPKbqjQ=";
      };

      env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

      makeCacheWritable = true;
      inherit npmBuildScript installPhase;

      preBuild = ''
        ln -s ../node_modules native/node_modules
      '';

      buildInputs = [
        libsecret
      ];

      nativeBuildInputs = [
        cargo
        (python3.withPackages (ps: with ps; [ setuptools ]))
        pkg-config
        rustc
        rustPlatform.cargoSetupHook
      ];

      meta = {
        description = "LDAP connector for Bitwarden";
        homepage = "https://github.com/bitwarden/directory-connector";
        license = lib.licenses.gpl3Only;
        maintainers = with lib.maintainers; [
          Silver-Golden
          SuperSandro2000
        ];
        platforms = lib.platforms.linux;
        mainProgram = name;
      };
    });
in
{
  bitwarden-directory-connector = common {
    name = "bitwarden-directory-connector";
    npmBuildScript = "build:dist";
    installPhase = ''
      runHook preInstall

      npm exec electron-builder -- \
        --dir \
        -c.electronDist=${electron.dist} \
        -c.electronVersion=${electron.version} \
        -c.npmRebuild=false

      mkdir -p $out/share/bitwarden-directory-connector $out/bin
      cp -r dist/*-unpacked/{locales,resources{,.pak}} $out/share/bitwarden-directory-connector

      makeWrapper ${lib.getExe electron} $out/bin/bitwarden-directory-connector \
        --add-flags $out/share/bitwarden-directory-connector/resources/app.asar \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
        --set-default ELECTRON_IS_DEV 0 \
        --inherit-argv0

      runHook postInstall
    '';
  };

  bitwarden-directory-connector-cli = common {
    name = "bitwarden-directory-connector-cli";
    npmBuildScript = "build:cli:prod";
    installPhase = ''
      runHook preInstall

      mkdir -p $out/libexec/bitwarden-directory-connector
      cp -R build-cli native node_modules $out/libexec/bitwarden-directory-connector

      # needs to be wrapped with nodejs so that it can be executed
      chmod +x $out/libexec/bitwarden-directory-connector/build-cli/bwdc.js
      mkdir -p $out/bin
      ln -s $out/libexec/bitwarden-directory-connector/build-cli/bwdc.js $out/bin/bitwarden-directory-connector-cli

      runHook postInstall
    '';
  };
}
