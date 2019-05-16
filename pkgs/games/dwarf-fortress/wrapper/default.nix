{ stdenv, lib, buildEnv, substituteAll, runCommand
, dwarf-fortress, dwarf-fortress-unfuck
, dwarf-therapist
, enableDFHack ? false, dfhack
, enableSoundSense ? false, soundSense, jdk
, enableStoneSense ? false
, enableTWBT ? false, twbt
, themes ? {}
, theme ? null
# General config options:
, enableIntro ? true
, enableTruetype ? true
, enableFPS ? false
, enableTextMode ? false
}:

let
  dfhack_ = dfhack.override {
    inherit enableStoneSense;
    inherit enableTWBT;
  };

  ptheme =
    if builtins.isString theme
    then builtins.getAttr theme themes
    else theme;

  unBool = b: if b then "YES" else "NO";

  # These are in inverse order for first packages to override the next ones.
  themePkg = lib.optional (theme != null) ptheme;
  pkgs = lib.optional enableDFHack dfhack_
         ++ lib.optional enableSoundSense soundSense
         ++ lib.optional enableTWBT twbt.art
         ++ [ dwarf-fortress ];

  fixup = lib.singleton (runCommand "fixup" {} (''
    mkdir -p $out/data/init
  '' + (if (theme != null) then ''
    cp ${lib.head themePkg}/data/init/init.txt $out/data/init/init.txt
  '' else ''
    cp ${dwarf-fortress}/data/init/init.txt $out/data/init/init.txt
  '') + lib.optionalString enableDFHack ''
    mkdir -p $out/hack

    # Patch the MD5
    orig_md5=$(cat "${dwarf-fortress}/hash.md5.orig")
    patched_md5=$(cat "${dwarf-fortress}/hash.md5")
    input_file="${dfhack_}/hack/symbols.xml"
    output_file="$out/hack/symbols.xml"

    echo "[DFHack Wrapper] Fixing Dwarf Fortress MD5:"
    echo "  Input:   $input_file"
    echo "  Search:  $orig_md5"
    echo "  Output:  $output_file"
    echo "  Replace: $patched_md5"

    substitute "$input_file" "$output_file" --replace "$orig_md5" "$patched_md5"
  '' + lib.optionalString enableTWBT ''
    substituteInPlace $out/data/init/init.txt \
      --replace '[PRINT_MODE:2D]' '[PRINT_MODE:TWBT]'
  '' + 
 lib.optionalString enableTextMode ''
    substituteInPlace $out/data/init/init.txt \
      --replace '[PRINT_MODE:2D]' '[PRINT_MODE:TEXT]'
  '' + ''
    substituteInPlace $out/data/init/init.txt \
      --replace '[INTRO:YES]' '[INTRO:${unBool enableIntro}]' \
      --replace '[TRUETYPE:YES]' '[TRUETYPE:${unBool enableTruetype}]' \
      --replace '[FPS:NO]' '[FPS:${unBool enableFPS}]'
  ''));

  env = buildEnv {
    name = "dwarf-fortress-env-${dwarf-fortress.dfVersion}";

    paths = fixup ++ themePkg ++ pkgs;
    pathsToLink = [ "/" "/hack" "/hack/scripts" ];

    ignoreCollisions = true;
  };
in

stdenv.mkDerivation rec {
  name = "dwarf-fortress-${dwarf-fortress.dfVersion}";

  dfInit = substituteAll {
    name = "dwarf-fortress-init";
    src = ./dwarf-fortress-init.in;
    inherit env;
    exe = if stdenv.isLinux then "libs/Dwarf_Fortress"
                            else "dwarfort.exe";
  };

  runDF = ./dwarf-fortress.in;
  runDFHack = ./dfhack.in;
  runSoundSense = ./soundSense.in;

  passthru = { inherit dwarf-fortress dwarf-therapist; };

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
}
