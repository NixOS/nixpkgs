{
  stdenv,
  lib,
  buildEnv,
  replaceVars,
  makeWrapper,
  runCommand,
  coreutils,
  gawk,
  dwarf-fortress,
  dwarf-therapist,
  SDL2_mixer,
  enableDFHack ? false,
  dfhack,
  enableSoundSense ? false,
  soundSense,
  jre,
  expect,
  xvfb-run,
  writeText,
  enableStoneSense ? false,
  enableTWBT ? false,
  twbt,
  themes ? { },
  theme ? null,
  extraPackages ? [ ],
  # General config options:
  enableIntro ? true,
  enableTruetype ? null, # defaults to 24, see init.txt
  enableFPS ? false,
  enableTextMode ? false,
  enableSound ? true,
  # An attribute set of settings to override in data/init/*.txt.
  # For example, `init.FOO = true;` is translated to `[FOO:YES]` in init.txt
  settings ? { },
# TODO world-gen.txt, interface.txt require special logic
}:

let
  dfhack' = dfhack.override {
    inherit enableStoneSense;
  };

  isAtLeast50 = dwarf-fortress.baseVersion >= 50;

  # If TWBT is null or the dfVersion is wrong, it isn't supported (for example, on version 50).
  enableTWBT' = enableTWBT && twbt != null && (twbt.dfVersion or null) == dwarf-fortress.version;

  ptheme = if builtins.isString theme then builtins.getAttr theme themes else theme;

  baseEnv = buildEnv {
    name = "dwarf-fortress-base-env-${dwarf-fortress.dfVersion}";

    # These are in inverse order for first packages to override the next ones.
    paths =
      extraPackages
      ++ lib.optional (theme != null) ptheme
      ++ lib.optional enableDFHack dfhack'
      ++ lib.optional enableSoundSense soundSense
      ++ lib.optionals enableTWBT' [
        twbt.lib
        twbt.art
      ]
      ++ [ dwarf-fortress ];

    ignoreCollisions = true;
  };

  settings' = lib.recursiveUpdate {
    init = {
      PRINT_MODE =
        if enableTextMode then
          "TEXT"
        else if enableTWBT' then
          "TWBT"
        else if stdenv.hostPlatform.isDarwin then
          "STANDARD" # https://www.bay12games.com/dwarves/mantisbt/view.php?id=11680
        else
          null;
      INTRO = enableIntro;
      TRUETYPE = enableTruetype;
      FPS = enableFPS;
      SOUND = enableSound;
    };
  } settings;

  forEach = attrs: f: lib.concatStrings (lib.mapAttrsToList f attrs);

  toTxt =
    v:
    if lib.isBool v then
      if v then "YES" else "NO"
    else if lib.isInt v then
      toString v
    else if lib.isString v then
      v
    else
      throw "dwarf-fortress: unsupported configuration value ${toString v}";

  config =
    runCommand "dwarf-fortress-config"
      {
        nativeBuildInputs = [
          gawk
          makeWrapper
        ];
      }
      (
        ''
          mkdir -p $out/data/init

          edit_setting() {
            v=''${v//'&'/'\&'}
            if [ -f "$out/$file" ]; then
              if ! gawk -i inplace -v RS='\r?\n' '
                { n += sub("\\[" ENVIRON["k"] ":[^]]*\\]", "[" ENVIRON["k"] ":" ENVIRON["v"] "]"); print }
                END { exit(!n) }
              ' "$out/$file"; then
                echo "error: no setting named '$k' in $out/$file" >&2
                exit 1
              fi
            else
              echo "warning: no file $out/$file; cannot edit" >&2
            fi
          }
        ''
        + forEach settings' (
          file: kv:
          ''
            file=data/init/${lib.escapeShellArg file}.txt
            if [ -f "${baseEnv}/$file" ]; then
              cp "${baseEnv}/$file" "$out/$file"
            else
              echo "warning: no file ${baseEnv}/$file; cannot copy" >&2
            fi
          ''
          + forEach kv (
            k: v:
            lib.optionalString (v != null) ''
              export k=${lib.escapeShellArg k} v=${lib.escapeShellArg (toTxt v)}
              edit_setting
            ''
          )
        )
        + lib.optionalString enableDFHack ''
          mkdir -p $out/hack

          # Patch the MD5
          orig_md5=$(< "${dwarf-fortress}/hash.md5.orig")
          patched_md5=$(< "${dwarf-fortress}/hash.md5")
          input_file="${dfhack'}/hack/symbols.xml"
          output_file="$out/hack/symbols.xml"

          echo "[DFHack Wrapper] Fixing Dwarf Fortress MD5:"
          echo "  Input:   $input_file"
          echo "  Search:  $orig_md5"
          echo "  Output:  $output_file"
          echo "  Replace: $patched_md5"

          substitute "$input_file" "$output_file" --replace-fail "$orig_md5" "$patched_md5"
        ''
      );

  # This is a separate environment because the config files to modify may come
  # from any of the paths in baseEnv.
  env = buildEnv {
    name = "dwarf-fortress-env-${dwarf-fortress.dfVersion}";
    paths = [
      config
      baseEnv
    ];
    ignoreCollisions = true;
  };
in

lib.throwIf (enableTWBT' && !enableDFHack) "dwarf-fortress: TWBT requires DFHack to be enabled"
  lib.throwIf
  (enableStoneSense && !enableDFHack)
  "dwarf-fortress: StoneSense requires DFHack to be enabled"
  lib.throwIf
  (enableTextMode && enableTWBT')
  "dwarf-fortress: text mode and TWBT are mutually exclusive"

  stdenv.mkDerivation
  {
    pname = "dwarf-fortress";
    version = dwarf-fortress.dfVersion;

    dfInit = replaceVars ./dwarf-fortress-init.in {
      inherit env;
      stdenv_shell = "${stdenv.shell}";
      cp = "${coreutils}/bin/cp";
      rm = "${coreutils}/bin/rm";
      ln = "${coreutils}/bin/ln";
      cat = "${coreutils}/bin/cat";
      mkdir = "${coreutils}/bin/mkdir";
      printf = "${coreutils}/bin/printf";
      uname = "${coreutils}/bin/uname";
      SDL2_mixer = "${SDL2_mixer}/lib/libSDL2_mixer.so";
    };

    runDF = ./dwarf-fortress.in;
    runSoundSense = ./soundSense.in;

    passthru = {
      inherit
        dwarf-fortress
        dwarf-therapist
        twbt
        env
        ;
      dfhack = dfhack';
    };

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out/bin

      substitute $runDF $out/bin/dwarf-fortress \
        --subst-var-by stdenv_shell ${stdenv.shell} \
        --subst-var-by dfExe ${dwarf-fortress.exe} \
        --subst-var dfInit
      chmod 755 $out/bin/dwarf-fortress
    ''
    + lib.optionalString enableDFHack ''
      substitute $runDF $out/bin/dfhack \
        --subst-var-by stdenv_shell ${stdenv.shell} \
        --subst-var-by dfExe dfhack \
        --subst-var dfInit
      chmod 755 $out/bin/dfhack
    ''
    + lib.optionalString enableSoundSense ''
      substitute $runSoundSense $out/bin/soundsense \
        --subst-var-by stdenv_shell ${stdenv.shell} \
        --subst-var-by jre ${jre} \
        --subst-var dfInit
      chmod 755 $out/bin/soundsense
    '';

    doInstallCheck = stdenv.hostPlatform.isLinux;
    nativeInstallCheckInputs = lib.optionals stdenv.hostPlatform.isLinux [
      expect
      xvfb-run
    ];

    installCheckPhase =
      let
        commonExpectStatements = ''
          expect "Loading bindings from data/init/interface.txt"
        '';
        dfHackExpectScript = writeText "dfhack-test.exp" (
          ''
            spawn env NIXPKGS_DF_OPTS=debug xvfb-run $env(out)/bin/dfhack
          ''
          + commonExpectStatements
          + ''
            expect "DFHack is ready. Have a nice day!"
            expect "DFHack version ${dfhack'.version}"
            expect "\[DFHack\]#"
            send -- "lua print(os.getenv('out'))\r"
            expect "$env(out)"
            # Don't send 'die' here; just exit. Some versions of dfhack crash on exit.
            exit 0
          ''
        );
        vanillaExpectScript =
          fmod:
          writeText "vanilla-test.exp" (
            ''
              spawn env NIXPKGS_DF_OPTS=debug,${lib.optionalString fmod "fmod"} xvfb-run $env(out)/bin/dwarf-fortress
            ''
            + commonExpectStatements
            + ''
              exit 0
            ''
          );
      in
      ''
        export HOME="$(mktemp -dt dwarf-fortress.XXXXXX)"
      ''
      + lib.optionalString enableDFHack ''
        expect ${dfHackExpectScript}
        df_home="$(find ~ -name "df_*" | head -n1)"
        test -f "$df_home/dfhack"
      ''
      + lib.optionalString isAtLeast50 ''
        expect ${vanillaExpectScript true}
        df_home="$(find ~ -name "df_*" | head -n1)"
        test ! -f "$df_home/dfhack"
        test -f "$df_home/libfmod_plugin.so"
      ''
      + ''
        expect ${vanillaExpectScript false}
        df_home="$(find ~ -name "df_*" | head -n1)"
        test ! -f "$df_home/dfhack"
        test ! -f "$df_home/libfmod_plugin.so"
      ''
      + ''
        test -d "$df_home/data"
      '';

    inherit (dwarf-fortress) meta;
  }
