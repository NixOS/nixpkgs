{ stdenv, lib, buildEnv, dwarf-fortress-original, substituteAll
, enableDFHack ? false, dfhack
, themes ? {}
, theme ? null
}:

let
  ptheme =
    if builtins.isString theme
    then builtins.getAttr theme themes
    else theme;

  # These are in inverse order for first packages to override the next ones.
  pkgs = lib.optional (theme != null) ptheme
         ++ lib.optional enableDFHack dfhack
         ++ [ dwarf-fortress-original ];

  env = buildEnv {
    name = "dwarf-fortress-env-${dwarf-fortress-original.dfVersion}";
    paths = pkgs;
    ignoreCollisions = true;
    postBuild = lib.optionalString enableDFHack ''
      # #4621
      if [ -L "$out/hack" ]; then
        rm $out/hack
        mkdir $out/hack
        for i in ${dfhack}/hack/*; do
          ln -s $i $out/hack
        done
      fi
      rm $out/hack/symbols.xml
      substitute ${dfhack}/hack/symbols.xml $out/hack/symbols.xml \
        --replace $(cat ${dwarf-fortress-original}/hash.md5.orig) \
                  $(cat ${dwarf-fortress-original}/hash.md5)
    '';
  };
in

assert lib.all (x: x.dfVersion == dwarf-fortress-original.dfVersion) pkgs;

stdenv.mkDerivation rec {
  name = "dwarf-fortress-${dwarf-fortress-original.dfVersion}";

  dfInit = substituteAll {
    name = "dwarf-fortress-init";
    src = ./dwarf-fortress-init.in;
    inherit env;
  };

  runDF = ./dwarf-fortress.in;
  runDFHack = ./dfhack.in;

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
  '';

  preferLocalBuild = true;
}
