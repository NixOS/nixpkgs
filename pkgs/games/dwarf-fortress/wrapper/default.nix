{ stdenv, lib, dwarf-fortress-original, substituteAll
, enableDFHack ? false, dfhack
}:

assert enableDFHack -> (dfhack.dfVersion == dwarf-fortress-original.dfVersion);

stdenv.mkDerivation rec {
  name = "dwarf-fortress-${dwarf-fortress-original.dfVersion}";

  runDF = ./dwarf-fortress.in;
  runDFHack = ./dfhack.in;
  dfInit = substituteAll {
    name = "dwarf-fortress-init";
    src = ./dwarf-fortress-init.in;
    dwarfFortress = dwarf-fortress-original;
  };
  inherit dfhack;
  df = dwarf-fortress-original;

  buildCommand = ''
    mkdir -p $out/bin

    substitute $runDF $out/bin/dwarf-fortress \
      --subst-var-by stdenv_shell ${stdenv.shell} \
      --subst-var dfInit
    chmod 755 $out/bin/dwarf-fortress
  '' + lib.optionalString enableDFHack ''
    mkdir -p $out/hack
    substitute $dfhack/hack/symbols.xml $out/hack/symbols.xml \
      --replace $(cat $df/full-hash-orig.md5) $(cat $df/full-hash-patched.md5)

    substitute $runDFHack $out/bin/dfhack \
      --subst-var-by stdenv_shell ${stdenv.shell} \
      --subst-var dfInit \
      --subst-var dfhack \
      --subst-var-by dfhackWrapper $out
    chmod 755 $out/bin/dfhack
  '';

  preferLocalBuild = true;

  meta = {
    description = "A single-player fantasy game with a randomly generated adventure world";
    homepage = http://www.bay12games.com/dwarves;
    maintainers = with lib.maintainers; [ a1russell robbinch roconnor the-kenny ];
  };
}
