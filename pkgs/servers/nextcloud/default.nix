{
  lib,
  stdenvNoCC,
  nixosTests,
  cacert,
  caBundle ? "${cacert}/etc/ssl/certs/ca-bundle.crt",
  nextcloud30Packages,
  nextcloud31Packages,
  buildNpmPackage,
  fetchFromGitHub,
  php,
  pkg-config,
  pixman,
  cairo,
  pango,
  jq,
  fetchzip,
  buildNextcloudApp,
  writeText,
  callPackage,
  importNpmLock,
}:
let
  generic =
    {
      version,
      hashes,
      eol ? false,
      extraVulnerabilities ? [ ],
      packages,
    }:
    let
      fetchNextcloudRepo =
        {
          name,
          version,
          hash,
        }:
        fetchFromGitHub {
          inherit name hash;
          owner = "nextcloud";
          repo = name;
          rev = "refs/tags/v${version}";
          fetchSubmodules = true;
        };
      src = fetchNextcloudRepo {
        inherit version;
        name = "server";
        hash = hashes.server.src;
      };
      dist = buildNpmPackage {
        inherit
          version
          src
          ;
        pname = "nextcloud-server-dist";
        npmDepsHash = hashes.server.npmDeps;
        makeCacheWritable = true;
        PUPPETEER_SKIP_DOWNLOAD = 1;
        CYPRESS_INSTALL_BINARY = 0;

        patchPhase = ''
          runHook prePatch

          rm -rf Makefile dist

          runHook postPatch
        '';

        postInstall = ''
          cp -r $out/lib/node_modules/*/dist /tmp
          rm -r $out
          mkdir $out
          cp -r /tmp/dist/. $out
        '';
      };
      skeleton = fetchNextcloudRepo rec {
        inherit version;
        name = "example-files";
        hash = hashes.${name}.src;
      };
      documentation = callPackage ./documentation.nix {
        # The documentation is not versioned, so the correct commit hash has to be set manually.
        rev =
          {
            "30.0.15" = "e71795c7d2a2d9e64e23f5df815bb2bd982e2480";
            "31.0.9" = "3032c4678d3eb7d690972525572e7974ffd3ccf4";
          }
          .${version};
        hash = hashes.documentation.src;
      };
      apps =
        lib.genAttrs
          (builtins.filter (
            shipped_app:
            !builtins.pathExists "${src}/apps/${shipped_app}"
            # The source of this app is not publicly available
            && shipped_app != "support"
          ) (builtins.fromJSON (builtins.readFile "${src}/core/shipped.json")).shippedApps)
          (
            app:
            let
              src = fetchNextcloudRepo {
                inherit version;
                name = app;
                hash = hashes.${app}.src;
              };
            in
            buildNextcloudApp (
              {
                inherit version src;
                pname = "nextcoud-${app}";
                license = lib.licenses.agpl3Plus;
                changelog = "https://nextcloud.com/changelog/#${lib.replaceStrings [ "." ] [ "-" ] version}";
                description = "Nextcloud ${app} app";
                homepage = "https://github.com/nextcloud/${app}";

                npmDepsHash = if builtins.hasAttr "npmDeps" hashes.${app} then hashes.${app}.npmDeps else null;
                vendorHash = if builtins.hasAttr "vendor" hashes.${app} then hashes.${app}.vendor else null;
              }
              // lib.optionalAttrs (app == "files_pdfviewer") {
                npmNativeBuildInputs = [
                  pkg-config
                ];

                npmBuildInputs = [
                  pixman
                  cairo
                  pango
                ];

                # Replicates https://github.com/nextcloud/files_pdfviewer/blob/master/pdfjs-get.js, but avoids downloading files at build time
                npmPostPatch = ''
                  ${lib.getExe jq} "del(.scripts.prebuild)" package.json > tmp.json
                  mv tmp.json package.json

                  mkdir -p js/pdfjs
                  cp -r ${
                    let
                      version =
                        (builtins.fromJSON (builtins.readFile "${src}/package-lock.json")).dependencies.pdfjs-dist.version;
                    in
                    fetchzip {
                      url = "https://github.com/mozilla/pdf.js/releases/download/v${version}/pdfjs-${version}-dist.zip";
                      hash =
                        {
                          "4.0.189" = "sha256-jARCCU5JQqsgl33GGEfbRqNUOR+atqVZlltjIIvnTjc=";
                        }
                        .${version};
                      stripRoot = false;
                    }
                  }/. js/pdfjs
                '';
              }
              // lib.optionalAttrs (app == "password_policy") {
                # Common password lists
                extraFiles = [ "lists" ];
              }
              // lib.optionalAttrs (app == "photos" && version == "31.0.9") {
                # TODO: Remove with v31.0.10: https://github.com/nextcloud/photos/pull/3179, https://github.com/nextcloud/photos/pull/3182
                src = stdenvNoCC.mkDerivation {
                  inherit src;
                  name = app;

                  buildPhase = ''
                    cp ${./photos-v31.0.9-package-lock.json} package-lock.json
                  '';

                  installPhase = ''
                    mkdir $out
                    cp -r ./. $out
                  '';
                };

                # To prevent https://github.com/nextcloud-libraries/webpack-vue-config/blob/main/scripts/postinstall.js from crashing
                npmRebuildFlags = [ "--ignore-scripts" ];
                # Due to --ignore-scripts https://github.com/vueuse/vue-demi/blob/main/scripts/postinstall.js doesn't run and the files for the wrong vue version are used
                npmPreBuild = ''
                  cp -r node_modules/vue-demi/lib/v2.7/. node_modules/vue-demi/lib
                '';
              }
              //
                lib.optionalAttrs
                  (
                    (app == "text" && (version == "30.0.15" || version == "31.0.9"))
                    || (app == "firstrunwizard" && (version == "30.0.15" || version == "31.0.9"))
                    || (app == "viewer" && version == "31.0.9")
                  )
                  {
                    # Pulls in some peer unnecessary dependencies at build time
                    npmFlags = [ "--legacy-peer-deps" ];
                  }
            )
          );
    in
    stdenvNoCC.mkDerivation rec {
      pname = "nextcloud-server";
      inherit version src;

      prePatch = ''
        rm Makefile
      '';

      postPatch = ''
        cp ${caBundle} resources/config/ca-bundle.crt
      '';

      buildPhase = ''
        rm -r core/{src,.l10nignore} apps/*/{src,l10n/.gitkeep} 3rdparty/{.github,.gitignore,README.md}

        rm -r core/skeleton
        mkdir core/skeleton
        cp -r ${skeleton}/. core/skeleton
        cp "${documentation}/Nextcloud Manual.pdf" core/skeleton

        rm -r core/doc/user
        ln -s ${documentation}/user core/doc/user
        rm -r core/doc/admin
        ln -s ${documentation}/admin core/doc/admin

        rm -r dist
        ln -s ${dist} dist

        ${lib.getExe php} ${writeText "generation-version.php" ''
          <?php
          declare(strict_types=1);
          require('${src}/version.php');
          $content = ["<?php"];
          ${lib.concatStringsSep "\n" (
            map (var: "$content[] = '$" + var + " = ' . var_export($" + var + ", true) . ';';") [
              "OC_Version"
              "OC_VersionString"
              "OC_VersionCanBeUpgradedFrom"
              "vendor"
            ]
          )}
          $content[] = '$OC_Build = "nixpkgs ${version}";';
          $content[] = '$OC_Edition = "";';
          $content[] = '$OC_Channel = "stable";';
          file_put_contents('version.php', implode("\n", $content));
        ''}
      '';

      installPhase = ''
        mkdir $out

        cp -r ${
          lib.concatStringsSep " " [
            ".htaccess"
            ".user.ini"
            "3rdparty"
            "AUTHORS"
            "COPYING"
            "LICENSES"
            "REUSE.toml"
            "composer.json"
            "composer.lock"
            "config"
            "console.php"
            "core"
            "cron.php"
            "dist"
            "index.html"
            "index.php"
            "lib"
            "occ"
            "ocs"
            "ocs-provider"
            "package-lock.json"
            "package.json"
            "public.php"
            "remote.php"
            "resources"
            "robots.txt"
            "status.php"
            "themes"
            "version.php"
          ]
        } $out

        for dir in apps/*; do
          app=$(basename $dir)
          # This app is only for development purposes
          if [[ "$app" == "testing" ]]; then
            continue
          fi

          pushd $dir
          mkdir -p $out/apps/$app
          cp -r appinfo lib $out/apps/$app
          if [ ! -f .noopenapi ]; then
            cp openapi*.json $out/apps/$app
          fi
          ${lib.concatStringsSep "\n" (
            map
              (entry: ''
                if [ -e ${entry} ]; then
                  cp -r ${entry} $out/apps/$app
                fi
              '')
              [
                "3rdparty"
                "ajax"
                "composer" # These are only autoloaders and not dependencies, so it's fine to not build them from source
                "css"
                "img"
                "js"
                "l10n"
                "templates"
              ]
          )}
          if [[ "$app" == "settings" ]]; then
            cp -r data $out/apps/$app
          fi
          if [[ "$app" == "theming" ]]; then
            cp -r fonts $out/apps/$app
          fi
          popd
        done

        ${lib.concatStringsSep "\n" (
          lib.mapAttrsToList (name: path: "ln -s ${path} $out/apps/${name}") apps
        )}
      '';

      passthru = {
        tests = lib.filterAttrs (
          key: _: (lib.hasSuffix (lib.versions.major version) key)
        ) nixosTests.nextcloud;
        inherit packages;
      };

      meta = {
        changelog = "https://nextcloud.com/changelog/#${lib.replaceStrings [ "." ] [ "-" ] version}";
        description = "Sharing solution for files, calendars, contacts and more";
        homepage = "https://nextcloud.com";
        teams = [ lib.teams.nextcloud ];
        license = lib.licenses.agpl3Plus;
        platforms = lib.platforms.linux;
        knownVulnerabilities =
          extraVulnerabilities ++ (lib.optional eol "Nextcloud version ${version} is EOL");
      };
    };
  versions = builtins.fromJSON (builtins.readFile ./versions.json);
  packages = {
    "30" = nextcloud30Packages;
    "31" = nextcloud31Packages;
  };
in
lib.mapAttrs' (
  version: values:
  let
    major = builtins.elemAt (lib.splitString "." version) 0;
  in
  lib.nameValuePair "nextcloud${major}" (generic {
    inherit version;
    inherit (versions.${version}) hashes;
    packages = packages.${major};
  })
) versions
