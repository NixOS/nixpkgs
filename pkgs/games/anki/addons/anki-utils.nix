{
  lib,
  stdenv,
  symlinkJoin,
  lndir,
  formats,
  runCommand,
}:
{
  buildAnkiAddon = lib.extendMkDerivation {
    constructDrv = stdenv.mkDerivation;
    extendDrvArgs =
      finalAttrs:
      {
        pname,
        version,
        src,
        sourceRoot ? "",
        configurePhase ? ''
          runHook preConfigure
          runHook postConfigure
        '',
        buildPhase ? ''
          runHook preBuild
          runHook postBuild
        '',
        dontPatchELF ? true,
        dontStrip ? true,
        nativeBuildInputs ? [ ],
        passthru ? { },
        meta ? { },
        # Script run after "user_files" folder is populated.
        # Used when an add-on needs to process and change "user_files" based
        # on what the user added to it.
        processUserFiles ? "",
        ...
      }:
      {
        inherit
          version
          src
          sourceRoot
          configurePhase
          buildPhase
          dontPatchELF
          dontStrip
          nativeBuildInputs
          ;

        pname = "anki-addon-${pname}";

        installPrefix = "share/anki/addons/${pname}";

        installPhase = ''
          runHook preInstall

          mkdir -p "$out/$installPrefix/user_files"
          find . -mindepth 1 -maxdepth 1 | xargs -d'\n' mv -t "$out/$installPrefix/"

          runHook postInstall
        '';

        passthru = {
          withConfig =
            {
              # JSON add-on config. The available options for an add-on are in its
              # config.json file.
              # See https://addon-docs.ankiweb.net/addon-config.html#config-json
              config ? { },
              # Path to a folder to be merged with the add-on "user_files" folder.
              # See https://addon-docs.ankiweb.net/addon-config.html#user-files.
              userFiles ? null,
            }:
            let
              metaConfigFormat = formats.json { };
              addonMetaConfig = metaConfigFormat.generate "meta.json" { inherit config; };
            in
            symlinkJoin {
              pname = "${finalAttrs.pname}-with-config";
              inherit (finalAttrs) version meta;

              paths = [
                finalAttrs.finalPackage
              ];

              postBuild = ''
                cd $out/${finalAttrs.installPrefix}

                rm -f meta.json
                ln -s ${addonMetaConfig} meta.json

                ${
                  if (userFiles != null) then
                    ''
                      ${lndir}/bin/lndir -silent "${userFiles}" user_files
                    ''
                  else
                    ""
                }

                ${processUserFiles}
              '';
            };
        }
        // passthru;

        meta = {
          platforms = lib.platforms.all;
        }
        // meta;
      };
  };

  buildAnkiAddonsDir =
    addonPackages:
    let
      addonDirs = map (pkg: "${pkg}/share/anki/addons") addonPackages;
      addons = lib.concatMapStringsSep " " (p: "${p}/*") addonDirs;
    in
    runCommand "anki-addons" { } ''
      mkdir $out
      [[ '${addons}' ]] || exit 0
      for addon in ${addons}; do
        ln -s "$addon" $out/
      done
    '';
}
