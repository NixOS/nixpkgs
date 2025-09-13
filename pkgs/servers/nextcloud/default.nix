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
          name = "${name}-source";
          owner = "nextcloud";
          repo = name;
          tag = "v${version}";
          fetchSubmodules = true;
          inherit hash;
        };
      src = fetchNextcloudRepo {
        inherit version;
        name = "server";
        inherit (hashes.server) hash;
      };
      dist = buildNpmPackage {
        inherit
          version
          src
          ;
        pname = "nextcloud-server-dist";
        inherit (hashes.server) npmDepsHash;
        makeCacheWritable = true;
        PUPPETEER_SKIP_DOWNLOAD = 1;
        CYPRESS_INSTALL_BINARY = 0;

        postPatch = ''
          rm -rf Makefile
        '';

        installPhase = ''
          mkdir $out
          cp -r dist/. $out
        '';
      };
      skeleton = fetchNextcloudRepo rec {
        inherit version;
        name = "example-files";
        inherit (hashes.${name}) hash;
      };
      documentation = callPackage ./documentation.nix {
        inherit version;
        inherit (hashes.documentation) hash;
      };
      apps = lib.genAttrs extraApps (
        app:
        let
          src = fetchNextcloudRepo {
            inherit version;
            name = app;
            inherit (hashes.${app}) hash;
          };
        in
        buildNextcloudApp (
          {
            inherit src version;
            pname = "nextcloud-${app}";
            license = lib.licenses.agpl3Plus;
            changelog = "https://nextcloud.com/changelog/#${lib.replaceStrings [ "." ] [ "-" ] version}";
            description = "Nextcloud ${app} app";
            homepage = "https://github.com/nextcloud/${app}";
          }
          // lib.optionalAttrs (hashes.${app} ? "npmDepsHash") { inherit (hashes.${app}) npmDepsHash; }
          // lib.optionalAttrs (hashes.${app} ? "vendorHash") { inherit (hashes.${app}) vendorHash; }
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
        )
      );
    in
    stdenvNoCC.mkDerivation rec {
      pname = "nextcloud-server";
      inherit version src;

      postPatch = ''
        rm Makefile
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
