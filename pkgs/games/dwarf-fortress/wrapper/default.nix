{ stdenv
, lib
, buildEnv
, substituteAll
, runCommand
, coreutils
, gawk
, dwarf-fortress
, dwarf-therapist
, enableDFHack ? false
, dfhack
, enableSoundSense ? false
, soundSense
, jdk
, enableStoneSense ? false
, enableTWBT ? false
, twbt
, themes ? { }
, theme ? null
, extraPackages ? [ ]
  # General config options:
, enableIntro ? true
, enableTruetype ? null # defaults to 24, see init.txt
, enableFPS ? false
, enableTextMode ? false
, enableSound ? true
# An attribute set of settings to override in data/init/*.txt.
# For example, `init.FOO = true;` is translated to `[FOO:YES]` in init.txt
, settings ? { }
# TODO world-gen.txt, interface.txt require special logic
}:

let
  dfhack_ = dfhack.override {
    inherit enableStoneSense;
  };

  ptheme =
    if builtins.isString theme
    then builtins.getAttr theme themes
    else theme;

  baseEnv = buildEnv {
    name = "dwarf-fortress-base-env-${dwarf-fortress.dfVersion}";

    # These are in inverse order for first packages to override the next ones.
    paths = extraPackages
         ++ lib.optional (theme != null) ptheme
         ++ lib.optional enableDFHack dfhack_
         ++ lib.optional enableSoundSense soundSense
         ++ lib.optionals enableTWBT [ twbt.lib twbt.art ]
         ++ [ dwarf-fortress ];

    ignoreCollisions = true;
  };

  settings_ = lib.recursiveUpdate {
    init = {
      PRINT_MODE =
        if enableTextMode then "TEXT"
        else if enableTWBT then "TWBT"
        else if stdenv.hostPlatform.isDarwin then "STANDARD" # https://www.bay12games.com/dwarves/mantisbt/view.php?id=11680
        else null;
      INTRO = enableIntro;
      TRUETYPE = enableTruetype;
      FPS = enableFPS;
      SOUND = enableSound;
    };
  } settings;

  forEach = attrs: f: lib.concatStrings (lib.mapAttrsToList f attrs);

  toTxt = v:
    if lib.isBool v then if v then "YES" else "NO"
    else if lib.isInt v then toString v
    else if lib.isString v then v
    else throw "dwarf-fortress: unsupported configuration value ${toString v}";

  config = runCommand "dwarf-fortress-config" {
    nativeBuildInputs = [ gawk ];
  } (''
    mkdir -p $out/data/init

    edit_setting() {
      v=''${v//'&'/'\&'}
      if ! gawk -i inplace -v RS='\r?\n' '
        { n += sub("\\[" ENVIRON["k"] ":[^]]*\\]", "[" ENVIRON["k"] ":" ENVIRON["v"] "]"); print }
        END { exit(!n) }
      ' "$out/$file"; then
        echo "error: no setting named '$k' in $file" >&2
        exit 1
      fi
    }
  '' + forEach settings_ (file: kv: ''
    file=data/init/${lib.escapeShellArg file}.txt
    cp ${baseEnv}/"$file" "$out/$file"
  '' + forEach kv (k: v: lib.optionalString (v != null) ''
    export k=${lib.escapeShellArg k} v=${lib.escapeShellArg (toTxt v)}
    edit_setting
  '')) + lib.optionalString enableDFHack ''
    mkdir -p $out/hack

    # Patch the MD5
    orig_md5=$(< "${dwarf-fortress}/hash.md5.orig")
    patched_md5=$(< "${dwarf-fortress}/hash.md5")
    input_file="${dfhack_}/hack/symbols.xml"
    output_file="$out/hack/symbols.xml"

    echo "[DFHack Wrapper] Fixing Dwarf Fortress MD5:"
    echo "  Input:   $input_file"
    echo "  Search:  $orig_md5"
    echo "  Output:  $output_file"
    echo "  Replace: $patched_md5"

    substitute "$input_file" "$output_file" --replace "$orig_md5" "$patched_md5"
  '');

  # This is a separate environment because the config files to modify may come
  # from any of the paths in baseEnv.
  env = buildEnv {
    name = "dwarf-fortress-env-${dwarf-fortress.dfVersion}";
    paths = [ config baseEnv ];
    ignoreCollisions = true;
  };
in

lib.throwIf (enableTWBT && !enableDFHack) "dwarf-fortress: TWBT requires DFHack to be enabled"
lib.throwIf (enableStoneSense && !enableDFHack) "dwarf-fortress: StoneSense requires DFHack to be enabled"
lib.throwIf (enableTextMode && enableTWBT) "dwarf-fortress: text mode and TWBT are mutually exclusive"

stdenv.mkDerivation {
  pname = "dwarf-fortress";
  version = dwarf-fortress.dfVersion;

  dfInit = substituteAll {
    name = "dwarf-fortress-init";
    src = ./dwarf-fortress-init.in;
    inherit env;
    exe =
      if stdenv.isLinux then "libs/Dwarf_Fortress"
      else "dwarfort.exe";
    stdenv_shell = "${stdenv.shell}";
    cp = "${coreutils}/bin/cp";
    rm = "${coreutils}/bin/rm";
    ln = "${coreutils}/bin/ln";
    cat = "${coreutils}/bin/cat";
    mkdir = "${coreutils}/bin/mkdir";
  };

  runDF = ./dwarf-fortress.in;
  runDFHack = ./dfhack.in;
  runSoundSense = ./soundSense.in;

  passthru = {
    inherit dwarf-fortress dwarf-therapist twbt env;
    dfhack = dfhack_;
  };

  buildCommand = ''
    mkdir -p $out/bin

    substitute $runDF $out/bin/dwarf-fortress \
      --subst-var-by stdenv_shell ${stdenv.shell} \
      --subst-var dfInit
    chmod 755 $out/bin/dwarf-fortress
  '' + lib.optionalString enableDFHack ''
    substitute $runDFHack $out/bin/dfhack \
      --subst-var-by stdenv_shell ${stdenv.shell} \
      --subst-var dfInit
    chmod 755 $out/bin/dfhack
  '' + lib.optionalString enableSoundSense ''
    substitute $runSoundSense $out/bin/soundsense \
      --subst-var-by stdenv_shell ${stdenv.shell} \
      --subst-var-by jre ${jdk.jre} \
      --subst-var dfInit
    chmod 755 $out/bin/soundsense
  '';

  preferLocalBuild = true;

  inherit (dwarf-fortress) meta;
}
