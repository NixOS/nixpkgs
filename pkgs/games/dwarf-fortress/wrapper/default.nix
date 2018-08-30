{ stdenv, lib, buildEnv, dwarf-fortress, substituteAll
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

  env = buildEnv {
    name = "dwarf-fortress-env-${dwarf-fortress.dfVersion}";

    paths = themePkg ++ pkgs;
    pathsToLink = [ "/" "/hack" "/hack/scripts" ];
    ignoreCollisions = true;

    postBuild = ''
      # De-symlink init.txt
      cp $out/data/init/init.txt init.txt
      rm $out/data/init/init.txt
      mv init.txt $out/data/init/init.txt
    '' + lib.optionalString enableDFHack ''
      rm $out/hack/symbols.xml
      substitute ${dfhack_}/hack/symbols.xml $out/hack/symbols.xml \
        --replace $(cat ${dwarf-fortress}/hash.md5.orig) \
                  $(cat ${dwarf-fortress}/hash.md5)
    '' + lib.optionalString enableTWBT ''
      substituteInPlace $out/data/init/init.txt \
        --replace '[PRINT_MODE:2D]' '[PRINT_MODE:TWBT]'
    '' + ''
      substituteInPlace $out/data/init/init.txt \
        --replace '[INTRO:YES]' '[INTRO:${unBool enableIntro}]' \
        --replace '[TRUETYPE:YES]' '[TRUETYPE:${unBool enableTruetype}]' \
        --replace '[FPS:NO]' '[FPS:${unBool enableFPS}]'
    '';
  };
in

stdenv.mkDerivation rec {
  name = "dwarf-fortress-${dwarf-fortress.dfVersion}";

  compatible = lib.all (x: assert (x.dfVersion == dwarf-fortress.dfVersion); true) pkgs;

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

  passthru = { inherit dwarf-fortress; };

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
