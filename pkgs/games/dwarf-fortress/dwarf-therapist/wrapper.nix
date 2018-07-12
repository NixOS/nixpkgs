{ pkgs, stdenv, symlinkJoin, lib, dwarf-therapist, dwarf-fortress, makeWrapper }:

let
  platformSlug = if stdenv.targetPlatform.is32bit then
    "linux32" else "linux64";
  inifile = "linux/v0.${dwarf-fortress.baseVersion}.${dwarf-fortress.patchVersion}_${platformSlug}.ini";

in symlinkJoin {
  name = "dwarf-therapist-${dwarf-therapist.version}";
  
  wrapper = ./dwarf-therapist.in;

  paths = [ dwarf-therapist ];

  buildInputs = [ makeWrapper ];

  passthru = { inherit dwarf-fortress dwarf-therapist; };

  buildCommand = ''
    mkdir -p $out/bin
    ln -s $out/bin/dwarftherapist $out/bin/DwarfTherapist
    substitute $wrapper $out/bin/dwarftherapist \
      --subst-var-by stdenv_shell ${stdenv.shell} \
      --subst-var-by install $out \
      --subst-var-by therapist ${dwarf-therapist} \
      --subst-var-by qt_plugin_path "${pkgs.qt5.qtbase}/lib/qt-${pkgs.qt5.qtbase.qtCompatVersion}/plugins/platforms"

    chmod 755 $out/bin/dwarftherapist

    # Fix up memory layouts
    rm -rf $out/share/dwarftherapist/memory_layouts/linux
    mkdir -p $out/share/dwarftherapist/memory_layouts/linux
    origmd5=$(cat "${dwarf-fortress}/hash.md5.orig" | cut -c1-8)
    patchedmd5=$(cat "${dwarf-fortress}/hash.md5" | cut -c1-8)
    substitute \
      ${dwarf-therapist}/share/dwarftherapist/memory_layouts/${inifile} \
      $out/share/dwarftherapist/memory_layouts/${inifile} \
      --replace "$origmd5" "$patchedmd5"
  '';
}
