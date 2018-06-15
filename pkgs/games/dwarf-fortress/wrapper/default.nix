{ stdenv, lib, buildEnv, dwarf-fortress-original, substituteAll
, enableDFHack ? false, dfhack
, enableSoundSense ? false, soundSense, jdk
, enableStoneSense ? false
, themes ? {}
, theme ? null
}:

let
  dfhack_ = dfhack.override {
    inherit enableStoneSense;
  };

  ptheme =
    if builtins.isString theme
    then builtins.getAttr theme themes
    else theme;

  # These are in inverse order for first packages to override the next ones.
  pkgs = lib.optional (theme != null) ptheme
         ++ lib.optional enableDFHack dfhack_
         ++ lib.optional enableSoundSense soundSense
         ++ [ dwarf-fortress-original ];

  env = buildEnv {
    name = "dwarf-fortress-env-${dwarf-fortress-original.dfVersion}";

    paths = pkgs;
    pathsToLink = [ "/" "/hack" "/hack/scripts" ];
    ignoreCollisions = true;

    postBuild = lib.optionalString enableDFHack ''
      rm $out/hack/symbols.xml
      substitute ${dfhack_}/hack/symbols.xml $out/hack/symbols.xml \
        --replace $(cat ${dwarf-fortress-original}/hash.md5.orig) \
                  $(cat ${dwarf-fortress-original}/hash.md5)
    '';
  };
in

stdenv.mkDerivation rec {
  name = "dwarf-fortress-${dwarf-fortress-original.dfVersion}";

  compatible = lib.all (x: assert (x.dfVersion == dwarf-fortress-original.dfVersion); true) pkgs;

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
