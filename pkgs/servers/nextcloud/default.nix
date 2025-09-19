{
  lib,
  stdenvNoCC,
  fetchurl,
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
            "30.0.14" = "22fc2d17d797c25596a24e68668a326df968e597";
            "31.0.8" = "0820df7972be2c319f6c68009c4946913dad0f1d";
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
              // lib.optionalAttrs (app == "photos" && version == "31.0.8") {
                # TODO: Remove with v31.0.10: https://github.com/nextcloud/photos/pull/3179, https://github.com/nextcloud/photos/pull/3182
                src = stdenvNoCC.mkDerivation {
                  inherit src;
                  name = app;

                  buildPhase = ''
                    cp ${./photos-v31.0.8-package-lock.json} package-lock.json
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
              // lib.optionalAttrs (app == "text" && (version == "30.0.14" || version == "31.0.8")) {
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
            ".reuse"
            ".user.ini"
            "3rdparty"
            "AUTHORS"
            "COPYING"
            "LICENSES"
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
in
{
  nextcloud30 = generic {
    version = "30.0.14";
    packages = nextcloud30Packages;
    hashes = {
      example-files = {
        src = "sha256-8Ai0+Z4jPhAxtS4D5le93ymRGp6Ki7RT8XEInUpLyGI=";
      };
      documentation = {
        src = "sha256-2/bAXbB4wO9x3BqqNLCTmlnKXF1RmA4oL9B7QrHHLfk=";
      };
      server = {
        src = "sha256-Dd9IsSFB/jhNErLfHCUVxkdWy1FY99aj7vHM6X/FltU=";
        npmDeps = "sha256-v91MVn0Sk1qN53dRoI3BjjAtLe5NcFqizE+22pKMSYg=";
      };
      activity = {
        src = "sha256-8BPPQ0ikSPR9PW0dku6USb4USML2PQ0ipyQLkhQRCY0=";
        npmDeps = "sha256-CrmZ4AEyry3A0umQPezxvDG7hDu1s0PRdis/giB1XtU=";
        vendor = "sha256-SX2JUVW+ZxfRuF+SADfSCN7qamYZlr8d+P7RICrKsLs=";
      };
      app_api = {
        src = "sha256-J017v+awK1U/kiJxFESQUUdZ/yqsDXwDjDKiVdRqzQQ=";
        npmDeps = "sha256-WYlzZDBfT8P02lPPzUdIWukYZdBHbUWuNwZSVfigM7M=";
        vendor = "sha256-D/0wmvaY/Bz8rHSAH37JTvf/ZrpUoSGe2UKHiaEDgPo=";
      };
      bruteforcesettings = {
        src = "sha256-0Do1Py/yZw5dYDB5ULYO5zhWfi0wGC5rZ+rravjZOR8=";
        npmDeps = "sha256-sNcqAwnND1561zMoK99+KR4rNPDUbjqXCwtR88zpZ1c=";
        vendor = "sha256-W0IHyldId6XqravJSR+tCMpK5vvQjApzbBx8zxDix78=";
      };
      circles = {
        src = "sha256-gmpYIXT0Z6oZrGM7GNrtuPnKJ/Im0Su1HMtCcPPhpWo=";
        vendor = "sha256-qIxy12D34r/eqxBrY+HLuGZqVTXK7XQ88/UesRFEapM=";
      };
      files_downloadlimit = {
        src = "sha256-XKySATM279IGgu6Yp8U0MBFkRepabZX2bg1Svp59v80=";
        npmDeps = "sha256-LxPF4l7YEkUNNOMFD63EPAhbTOOVmIHkrR6LSvGX8a8=";
        vendor = "sha256-j+cHF4W69zpwigseg/U1OnyqIFcEGZXvzZs/rKB+bio=";
      };
      files_pdfviewer = {
        src = "sha256-9TNd9JbKTAGF1CJGS2nz28nEjpx3Gfm4Hh06qLerDj0=";
        npmDeps = "sha256-mcvdMtMWyyMf2i/wm24CXPUZyvffMSIO8gCcfiIoVNA=";
        vendor = "sha256-hNAe8idxy7wJW461q3toZSmNbGsA8sX+nU6UUzEfUvE=";
      };
      firstrunwizard = {
        src = "sha256-zVKu4hOvTNHXCrnC9TntdM0Lo9v3IPORN1VRpUlnmyw=";
        npmDeps = "sha256-OsNr7f2L+66CKPjmCk9rBgO7Amet0yZu4+Zyu8C+APY=";
        vendor = "sha256-ZbKtCseo8LqhJj8VQ+YuYqrgSZi1bph6MuMrZt4Sk60=";
      };
      logreader = {
        src = "sha256-883us0rg4w47UlZIN2OskDS59Bdf2q1zAoHRmrvXgw8=";
        npmDeps = "sha256-ca9pUwkYBkWPBo1/U1iT1Yq750Dcmc344dzQiISFazw=";
        vendor = "sha256-It9/r1lNsU+2SMnZE9VP8F0rYOymvQXKNWu0FeVbGbE=";
      };
      nextcloud_announcements = {
        src = "sha256-h69kh7YziAhlfdButrMXtrMZETHeSF+H+2+6kDq+lc8=";
        vendor = "sha256-+LHvuHKKRsiG88pjubq4D/is8+cO8HBU6vSJvVVYI3c=";
      };
      notifications = {
        src = "sha256-ZFYqiK9iyPvnAOxPN2co94O8PzjPxY4+NAC8ZbX7I9g=";
        npmDeps = "sha256-Ok2ngLY9vi8qymbFa/gbVpM3nRtr7EwzZ2OPE9CET/g=";
        vendor = "sha256-dqIm3PVnIBkUqO3ZA6He1WhC9PXrSrnqyE2X9UNzjkY=";
      };
      password_policy = {
        src = "sha256-itY6vtcy9gmyPhIkE5heMIAiUl2n571n+Tmx+5WoR/c=";
        npmDeps = "sha256-Xy+DmSagbniaNIGKcBfsaUgcE13fwzBj37KER398/54=";
        vendor = "sha256-0U3hjiGXFBMdTRxKEGQXUB1OoSlJS9CKSjRaG9lPKII=";
      };
      photos = {
        src = "sha256-4zn3o5XkguSwvQ4lNBNZap96Yy5vEeosdJH6AJm5UIU=";
        npmDeps = "sha256-Oa6MSvdvEQO6NxnPjZFKcmEEIMyBWAOG0ljsQfbGgUM=";
        vendor = "sha256-HBs3d9Iai4M2FjnyPzy+aIgkupcVgZWjLRaw/CSLrqQ=";
      };
      privacy = {
        src = "sha256-7cMVmyCdj1i4jirw7bWDhwcSzel0NkGyA/OIn4PJZLE=";
        npmDeps = "sha256-A0lUaeJMWGLbqrCK2pxLGQoac2tSJdYJqtp7VmBI26k=";
        vendor = "sha256-0m4pNVbu6PtD9jQO8J06t1caVwWZOv5+1HM+PCmPlkM=";
      };
      recommendations = {
        src = "sha256-5jz59Ojoyh7jQTAdty2/7A8aUi6nNP/Z1Kh4UjQkx7w=";
        npmDeps = "sha256-1JE5jY5TJeq6xCnqUgShlROFIWMY2E/saM5JNhUgPq8=";
        vendor = "sha256-ew5pcyd+bKa8IwMs8szWCtzyer2RVjATRgqdgWoaLPQ=";
      };
      related_resources = {
        src = "sha256-0RM+BWhROlphTakMlhhS/+ihxQa15LpiPG1RxSJ28MY=";
        npmDeps = "sha256-yAY7BmJFhEE162AqYNET/doHNNZVFrwoCmHqYRHyQl0=";
        vendor = "sha256-yrLXC50Gt4btZQZb0Op6b61Jf35lF5pCOMGAxrX5p7U=";
      };
      serverinfo = {
        src = "sha256-qSuD2vNrNZ5SBOWUZL0J0/G/rdh+pzB87mrNwxWLshU=";
        vendor = "sha256-OOODzcYqqFIq+M7T2OgkWfkjQuT4Apzh980I2I+Afr0=";
      };
      survey_client = {
        src = "sha256-gnT6BMi3LKPLqlO0WapIFERwihWrNGSok9IFhhjLP7k=";
        vendor = "sha256-48jgwaZy7hfCUHh1isPUj1pkBXoCRMVqjBNk4R+ucH8=";
      };
      suspicious_login = {
        src = "sha256-0CYDBNB9fkArhMvs5sKUVjYdrpMBZ980mBYm0cgGnuQ=";
        npmDeps = "sha256-z8ELNdRd4PLL6gCCaD5UzjpIrnG7kJlFF4yJOABTN6Y=";
        vendor = "sha256-SW/Vja8RvKrOK2YaLY69Ljl0ylll3weHDwJEc9zNYr8=";
      };
      text = {
        src = "sha256-ZTM7dEJvtWbBBxUHNUxBS0YBdd/mo8GRsfkxQztxhcE=";
        npmDeps = "sha256-stZsXOZk9jszFYm5mtrlnX02LQ0yVNHNFK2CgIdNdOc=";
        vendor = "sha256-qXy/KO0py0H6KRgBfwUesNOIkAgZLzygcocLEy8hk+g=";
      };
      twofactor_nextcloud_notification = {
        src = "sha256-hHSuVDxRNMiKD0Gtj8nFSIBh+qOeOg0VRP+um0cQBeE=";
        npmDeps = "sha256-OT097oLt//gvvOVx77irCW9t4TGoHSZrL8YWKNdoUHI=";
        vendor = "sha256-/5HCgyJeV3gnX5/zDx45uHVV5YxPp/Kdi0aaPqLRec0=";
      };
      twofactor_totp = {
        src = "sha256-tQCFhRe+paTiyEQpGrlizAtegRge+oUlqsB2HQmd3Gk=";
        npmDeps = "sha256-IrQ9mF/mcFw+XDhljfex6RKMPS1gGSTwJDEuSV/QDHs=";
        vendor = "sha256-Wm1dmaIYdH/MNwyRNc2zt1usolxMrV613sBB9UZK5eo=";
      };
      viewer = {
        src = "sha256-blGc7cFIdvAU6a6+Cm3D02s5Q0QAZ5LNbaXc13Zxbuk=";
        npmDeps = "sha256-re4NIwRkO32XH7x1eI1MyC9yw1gctkbQU00terJeVnA=";
        vendor = "sha256-n3OFunMgG6iDY8Vd3kJFhMhA30aAMgTLNTiwpP/uDKs=";
      };
    };
  };

  nextcloud31 = generic {
    version = "31.0.8";
    packages = nextcloud31Packages;
    hashes = {
      example-files = {
        src = "sha256-jq5uInl+2FKJTYJoztV61HsVPWK07S1fthA8mq9pwbw=";
      };
      documentation = {
        src = "sha256-5HB6w3yLW6cW5ioA2skLrUdxwO7A8R+chVf3l1I0Yu8=";
      };
      server = {
        src = "sha256-u85/QDu1Tfbq40JzELg5qKWy2ZeW7OpjMGSGSihMHMY=";
        npmDeps = "sha256-9xHSK5ikjvPOqSfB4U0wXsc7neC0v3inQIZthFgHxW8=";
      };
      activity = {
        src = "sha256-uqLOVLrI5MNQj7bwLNI34piZiYfW+ba6Dv4f/sIEB6Y=";
        npmDeps = "sha256-2xtS+07iK4oqL7S8/HrFJw/vKET0B5tS6h8HiVpNdbI=";
        vendor = "sha256-lxhLoKUCl/TFtQO+VchU7RDdXh+IYiUyk7IrXBQEaEQ=";
      };
      app_api = {
        src = "sha256-tD0cx2sMkFOAxOATFCi4BUSWSqh5/Lqc8mXZoPNbUFI=";
        npmDeps = "sha256-dO2NeKLM8K93LOSYBYdL6RmLIiTBWZoE/7WegvvLW/g=";
        vendor = "sha256-lxh1A5NkEWRPgFdw4gnNtlAW3feiABYl+qHwtbUpc60=";
      };
      bruteforcesettings = {
        src = "sha256-7uETQ+UOXuthR9KyH8tj1i5vQ2LTD4uNFzhPmlmTjks=";
        npmDeps = "sha256-UJr/DRgoGLRiAqzMuY+aBLzuBh5LJo5o9B2JAObcyMg=";
        vendor = "sha256-YksbnelIrA10rhhcGDas0C9gZOzs+CZYVdqSZE0TLog=";
      };
      circles = {
        src = "sha256-fixh+KWzBih+Xwxo54CqdINRgVw1vIfkh+mxQwMh3no=";
        vendor = "sha256-I4ikgqrAKRbNT4/v5a8II4RhknA+K2HWELqBP7dSfo4=";
      };
      files_downloadlimit = {
        src = "sha256-P5cQVSVOZNOhXCLHSlwAcKKrP60nNYa2p3z5wtzjR9s=";
        npmDeps = "sha256-vTyj86PNa2CGZQDl++sejKhY2JrVzrhXp/YhneUc9+0=";
        vendor = "sha256-fi5GhSQE8Zvlv8urY4Hx0rhwBJxH31tSjHXMpaXuhI4=";
      };
      files_pdfviewer = {
        src = "sha256-lyzZ5bZIGGlL3YZ6WI+Hr+/itF+MAyAcgP45/FUqaTw=";
        npmDeps = "sha256-dokACG16o7GEWUOOc4juzVZyiAQkIOVyG5LWXhdrIAM=";
        vendor = "sha256-IVf1pcTqjNr1xwCfgjf9CCYJGgabXWogWepLuPMj8T0=";
      };
      firstrunwizard = {
        src = "sha256-9Kx2oGWwgvCg6kh467AVaCCL5oQIeN+eQFyvSQBfwX8=";
        npmDeps = "sha256-mWXcp9i49K9CDGTU9Q8W/GTiyYkDo2tze5O84xuDdJg=";
        vendor = "sha256-JoYPiQUTtqackw0aAUoDNfX6+lj+Oc4ObeGahIm8wt8=";
      };
      logreader = {
        src = "sha256-wJoABjgweRZ+p7kzWnta7z0OpfvNxPJRU1/eRQqV39Y=";
        npmDeps = "sha256-ROvT0FXXqIroBPXsM9D1w8WYKrP13XwmoVO5VWWsdMU=";
        vendor = "sha256-JwCDjWEmDnZtzSG2fIJHBqKADFXBVshPxbJaoGk6Kqw=";
      };
      nextcloud_announcements = {
        src = "sha256-XNExLBdLmNH7B/d0xRvutPAaIHNML15TNiOh7iglTSc=";
        vendor = "sha256-1XrFs6a9E063YYvS4gdAKQ8uUzWr28r2lf1HQu7R148=";
      };
      notifications = {
        src = "sha256-Ao+buoKdqrNrWZcuITerdisXr63W/VDWXasEeJmGyHU=";
        npmDeps = "sha256-w4vSxq5Xl5qs21f0VArVwglB4VQAidfrZCU0k8U0dMQ=";
        vendor = "sha256-kaHJtXkuceMTaC6BYgME8P6RvVEGadmL/DL6pGPTj7M=";
      };
      password_policy = {
        src = "sha256-AxlIEuTeMXPWNZp/q2n/zmFOtbPIRSIdI8GDrnvWo8c=";
        npmDeps = "sha256-0rbuRTYcqfEq8sRDDc7YF5BMtl3uhZUIjsAixaefXxk=";
        vendor = "sha256-P3X1WbfKnMTeH0nFOiz7lFOSzTzmzY23x5jmd5tfFCU=";
      };
      photos = {
        src = "sha256-84jH0VmzQD65Ngb9C3FM/kaujpxkRNTO5Kpnpq0Z8UA=";
        npmDeps = "sha256-ZsnybQ2yd35JTN2LnfUB07Plz6r1Y2WoGmC9iR9PzVs=";
        vendor = "sha256-PVWzUcAoolP3okhCd1eM8mBLlQ5ZJ/5DyMNPIY9RtHI=";
      };
      privacy = {
        src = "sha256-4fg6NyyZ6hqBfFCVTN+9pUW10RwZ2Rq4YretFPlVwak=";
        npmDeps = "sha256-6XttrIpyIvRW2lz4V5YJzTAu6Gg9GQNE/njfvGSYej0=";
        vendor = "sha256-zXn2aSU/YQVAmeapxjUpjmL2jDKomOgkY2OYOqmxUYY=";
      };
      recommendations = {
        src = "sha256-RXO38Y/cEreieC/naNxfVjYN9JJQb+ZTZWBG2I37lPg=";
        npmDeps = "sha256-F0wGEiCQcOk4Vmsq28qersfcbCe4heJRz/EgeLoT9Sc=";
        vendor = "sha256-qfsfp+njKkqxOn8q3OwDo+QdfUnjnc5pRfSMjVnJDM8=";
      };
      related_resources = {
        src = "sha256-fZQ8Agwc/5LBcdjcIwRDqeHtNv/Mgn2BPKvoWF0BGBg=";
        npmDeps = "sha256-8yE+FGnaadzPH914MuRhAFDi86VPldYW9IO5nY/vZ0Y=";
        vendor = "sha256-wvyT9Awhalx4J6RH4JEgiFzn4y9gA7r2DqEvCeuFIkk=";
      };
      serverinfo = {
        src = "sha256-fx6Iva112NrbDeDDiorqg4MbOXrDRMqy5Xi5T6IutZI=";
        vendor = "sha256-2qzfkXT0lydSVl672D9MMO3K043Ov5GoE8xIIGHYaGg=";
      };
      survey_client = {
        src = "sha256-idLO/jpkDHs34oOnpmOqkTulPN83L+71CBY9aYTyS5g=";
        vendor = "sha256-n+7WjlDi1P7YjEITdn/D6rd23PEOrQ4I6p+cBWok8ME=";
      };
      suspicious_login = {
        src = "sha256-pwI2TBRGj5Z8xRpcYrV8Og+AjX4Op6tBWl8O3MAbhWs=";
        vendor = "sha256-eJCfYvKPIq3auid1K65DeLoLWEtGQ/TpSYZW78qvy+4=";
      };
      text = {
        src = "sha256-8YHbCSTiNY/t+yP9Y7alZRHQMHSXk/IxI+Pu8TT4hNQ=";
        npmDeps = "sha256-a0OPNB5sbclVFf7lQwfjzPXAQ9JjbgJlHwlGZSq9Vr8=";
        vendor = "sha256-yIHRDSNfj23V+e0BLCMofLOnNpXpkX/Ao6NT5KpGAmQ=";
      };
      twofactor_nextcloud_notification = {
        src = "sha256-cjbfQs2uhe9jLiXhstfc13PgUjHft49nO9/tYi2BzE0=";
        npmDeps = "sha256-Ax8Xb9ZRnrXQgfkJnxHFkqRrCX4OR8fBCB3UbtU3tw0=";
        vendor = "sha256-rDJVqKWsFhqaLxsstKtYYoZCjDA3iPUaWxz6NZKvUZg=";
      };
      twofactor_totp = {
        src = "sha256-fdWN5/xG0RpU24+3MrExUNbk+cSSehSrYYwFrLOgHls=";
        npmDeps = "sha256-OAdlpk5QaEWvrBEVbVlScDueM+0UIAQLRnPA9cCFibw=";
        vendor = "sha256-qvASoepZhG3taOJmejHztS2kAaQMP8oyUz6KQ/en0us=";
      };
      viewer = {
        src = "sha256-w0VeBYWQ5G0rFfbKmTJSbZujGLDNADL8Cz+lihdBOeQ=";
        npmDeps = "sha256-2WkQL3v2DSzFildPUfrp0tEh3J6Spf6q8QP+m169/20=";
        vendor = "sha256-n3x2ZcS6ol0frB6WMeGRTc5lcbhlqg85HTyy9U9eFik=";
      };
    };
  };
}
