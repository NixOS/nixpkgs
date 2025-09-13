{
  lib,
  stdenvNoCC,
  nixosTests,
  cacert,
  caBundle ? "${cacert}/etc/ssl/certs/ca-bundle.crt",
  nextcloud31Packages,
  nextcloud32Packages,
  buildNpmPackage,
  fetchFromGitHub,
  php,
  pkg-config,
  pixman,
  cairo,
  pango,
  jq,
  buildNextcloudApp,
  writeText,
  callPackage,
}:
let
  generic =
    {
      version,
      hashes,
      extraApps,
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

          rm -rf Makefile

          runHook postPatch
        '';

        installPhase = ''
          mkdir $out
          cp -r dist/. $out
        '';
      };
      skeleton = fetchNextcloudRepo rec {
        inherit version;
        name = "example-files";
        hash = hashes.${name}.src;
      };
      documentation = callPackage ./documentation.nix {
        inherit version;
        hash = hashes.documentation.src;
      };
      apps = lib.genAttrs extraApps (
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
            inherit src version;
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

            # Removes https://github.com/nextcloud/files_pdfviewer/blob/master/pdfjs-get.js, which tries to download files at build time.
            npmPostPatch = ''
              ${lib.getExe jq} "del(.scripts.prebuild)" package.json > tmp.json
              mv tmp.json package.json
            '';
          }
          // lib.optionalAttrs (app == "password_policy") {
            # Common password lists
            extraFiles = [ "lists" ];
          }
          //
            lib.optionalAttrs
              (
                version == "32.0.1"
                && (
                  # https://github.com/nextcloud/files_downloadlimit/pull/600
                  app == "files_downloadlimit"
                  # https://github.com/nextcloud/bruteforcesettings/pull/848
                  || app == "bruteforcesettings"
                  # https://github.com/nextcloud/twofactor_nextcloud_notification/pull/1095
                  || app == "twofactor_nextcloud_notification"
                  # https://github.com/nextcloud/recommendations/pull/933
                  || app == "recommendations"
                  # https://github.com/nextcloud/files_pdfviewer/pull/1301
                  || app == "files_pdfviewer"
                )
              )
              {
                src = stdenvNoCC.mkDerivation {
                  inherit src;
                  name = app;

                  buildPhase = ''
                    cp ${./. + "/${app}-${version}-package-lock.json"} package-lock.json
                    ${lib.optionalString (app == "files_pdfviewer")
                      "cp ${./. + "/${app}-${version}-package.json"} package.json"
                    }
                  '';

                  installPhase = ''
                    mkdir $out
                    cp -r ./. $out
                  '';
                };
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
    "31" = nextcloud31Packages;
    "32" = nextcloud32Packages;
  };
in
lib.mapAttrs' (
  version: values:
  let
    major = builtins.elemAt (lib.splitString "." version) 0;
  in
  lib.nameValuePair "nextcloud${major}" (generic {
    inherit version;
    inherit (versions.${version}) hashes extraApps;
    packages = packages.${major};
  })
) versions
