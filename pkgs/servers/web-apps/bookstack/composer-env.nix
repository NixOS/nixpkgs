# This file originates from composer2nix

{
  stdenv,
  lib,
  writeTextFile,
  fetchurl,
  php,
  unzip,
  phpPackages,
}:

let
  inherit (phpPackages) composer;

  filterSrc =
    src:
    builtins.filterSource (
      path: type:
      type != "directory"
      || (baseNameOf path != ".git" && baseNameOf path != ".git" && baseNameOf path != ".svn")
    ) src;

  buildZipPackage =
    { name, src }:
    stdenv.mkDerivation {
      inherit name src;
      nativeBuildInputs = [ unzip ];
      buildCommand = ''
        shopt -s dotglob
        unzip $src
        baseDir=$(find . -type d -mindepth 1 -maxdepth 1)
        cd $baseDir
        mkdir -p $out
        mv * $out
      '';
    };

  buildPackage =
    {
      name,
      src,
      packages ? { },
      devPackages ? { },
      buildInputs ? [ ],
      symlinkDependencies ? false,
      executable ? false,
      removeComposerArtifacts ? false,
      postInstall ? "",
      noDev ? false,
      composerExtraArgs ? "",
      unpackPhase ? "true",
      buildPhase ? "true",
      ...
    }@args:

    let
      reconstructInstalled = writeTextFile {
        name = "reconstructinstalled.php";
        executable = true;
        text = ''
          #! ${php}/bin/php
          <?php
          if(file_exists($argv[1]))
          {
              $composerLockStr = file_get_contents($argv[1]);

              if($composerLockStr === false)
              {
                  fwrite(STDERR, "Cannot open composer.lock contents\n");
                  exit(1);
              }
              else
              {
                  $config = json_decode($composerLockStr, true);

                  if(array_key_exists("packages", $config))
                      $allPackages = $config["packages"];
                  else
                      $allPackages = array();

                  ${
                    lib.optionalString (!noDev) ''
                      if(array_key_exists("packages-dev", $config))
                          $allPackages = array_merge($allPackages, $config["packages-dev"]);
                    ''
                  }

                  $packagesStr = json_encode($allPackages, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);
                  print($packagesStr);
              }
          }
          else
              print("[]");
          ?>
        '';
      };

      constructBin = writeTextFile {
        name = "constructbin.php";
        executable = true;
        text = ''
          #! ${php}/bin/php
          <?php
          $composerJSONStr = file_get_contents($argv[1]);

          if($composerJSONStr === false)
          {
              fwrite(STDERR, "Cannot open composer.json contents\n");
              exit(1);
          }
          else
          {
              $config = json_decode($composerJSONStr, true);

              if(array_key_exists("bin-dir", $config))
                  $binDir = $config["bin-dir"];
              else
                  $binDir = "bin";

              if(array_key_exists("bin", $config))
              {
                  if(!file_exists("vendor/".$binDir))
                      mkdir("vendor/".$binDir);

                  foreach($config["bin"] as $bin)
                      symlink("../../".$bin, "vendor/".$binDir."/".basename($bin));
              }
          }
          ?>
        '';
      };

      bundleDependencies =
        dependencies:
        lib.concatMapStrings (
          dependencyName:
          let
            dependency = dependencies.${dependencyName};
          in
          ''
            ${
              if dependency.targetDir == "" then
                ''
                  vendorDir="$(dirname ${dependencyName})"
                  mkdir -p "$vendorDir"
                  ${
                    if symlinkDependencies then
                      ''ln -s "${dependency.src}" "$vendorDir/$(basename "${dependencyName}")"''
                    else
                      ''cp -av "${dependency.src}" "$vendorDir/$(basename "${dependencyName}")"''
                  }
                ''
              else
                ''
                  namespaceDir="${dependencyName}/$(dirname "${dependency.targetDir}")"
                  mkdir -p "$namespaceDir"
                  ${
                    if symlinkDependencies then
                      ''ln -s "${dependency.src}" "$namespaceDir/$(basename "${dependency.targetDir}")"''
                    else
                      ''cp -av "${dependency.src}" "$namespaceDir/$(basename "${dependency.targetDir}")"''
                  }
                ''
            }
          ''
        ) (builtins.attrNames dependencies);

      extraArgs = removeAttrs args [
        "packages"
        "devPackages"
        "buildInputs"
      ];
    in
    stdenv.mkDerivation (
      {
        buildInputs = [
          php
          composer
        ] ++ buildInputs;

        inherit unpackPhase buildPhase;

        installPhase = ''
          ${
            if executable then
              ''
                mkdir -p $out/share/php
                cp -av $src $out/share/php/$name
                chmod -R u+w $out/share/php/$name
                cd $out/share/php/$name
              ''
            else
              ''
                cp -av $src $out
                chmod -R u+w $out
                cd $out
              ''
          }

          # Remove unwanted files
          rm -f *.nix

          export HOME=$TMPDIR

          # Remove the provided vendor folder if it exists
          rm -Rf vendor

          # If there is no composer.lock file, compose a dummy file.
          # Otherwise, composer attempts to download the package.json file from
          # the registry which we do not want.
          if [ ! -f composer.lock ]
          then
              cat > composer.lock <<EOF
          {
              "packages": []
          }
          EOF
          fi

          # Reconstruct the installed.json file from the lock file
          mkdir -p vendor/composer
          ${php}/bin/php ${reconstructInstalled} composer.lock > vendor/composer/installed.json

          # Copy or symlink the provided dependencies
          cd vendor
          ${bundleDependencies packages}
          ${lib.optionalString (!noDev) (bundleDependencies devPackages)}
          cd ..

          # Reconstruct autoload scripts
          # We use the optimize feature because Nix packages cannot change after they have been built
          # Using the dynamic loader for a Nix package is useless since there is nothing to dynamically reload.
          composer dump-autoload --optimize ${lib.optionalString noDev "--no-dev"} ${composerExtraArgs}

          # Run the install step as a validation to confirm that everything works out as expected
          composer install --optimize-autoloader ${lib.optionalString noDev "--no-dev"} ${composerExtraArgs}

          ${lib.optionalString executable ''
            # Reconstruct the bin/ folder if we deploy an executable project
            ${php}/bin/php ${constructBin} composer.json
            ln -s $(pwd)/vendor/bin $out/bin
          ''}

          ${lib.optionalString (!symlinkDependencies) ''
            # Patch the shebangs if possible
            if [ -d $(pwd)/vendor/bin ]
            then
                # Look for all executables in bin/
                for i in $(pwd)/vendor/bin/*
                do
                    # Look for their location
                    realFile=$(readlink -f "$i")

                    # Restore write permissions
                    chmod u+wx "$(dirname "$realFile")"
                    chmod u+w "$realFile"

                    # Patch shebang
                    sed -e "s|#!/usr/bin/php|#!${php}/bin/php|" \
                        -e "s|#!/usr/bin/env php|#!${php}/bin/php|" \
                        "$realFile" > tmp
                    mv tmp "$realFile"
                    chmod u+x "$realFile"
                done
            fi
          ''}

          if [ "$removeComposerArtifacts" = "1" ]
          then
              # Remove composer stuff
              rm -f composer.json composer.lock
          fi

          # Execute post install hook
          runHook postInstall
        '';
      }
      // extraArgs
    );
in
{
  inherit filterSrc;
  composer = lib.makeOverridable composer;
  buildZipPackage = lib.makeOverridable buildZipPackage;
  buildPackage = lib.makeOverridable buildPackage;
}
