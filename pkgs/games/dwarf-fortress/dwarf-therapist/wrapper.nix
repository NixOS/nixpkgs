{ pkgs, stdenv, symlinkJoin, lib, dwarf-therapist, dwarf-fortress, makeWrapper }:

let
  platformSlug = if stdenv.targetPlatform.is32bit then
    "linux32" else "linux64";
  inifile = "linux/v0.${dwarf-fortress.baseVersion}.${dwarf-fortress.patchVersion}_${platformSlug}.ini";

in
  
stdenv.mkDerivation rec {
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
    orig_md5=$(cat "${dwarf-fortress}/hash.md5.orig" | cut -c1-8)
    patched_md5=$(cat "${dwarf-fortress}/hash.md5" | cut -c1-8)
    input_file="${dwarf-therapist}/share/dwarftherapist/memory_layouts/${inifile}"
    output_file="$out/share/dwarftherapist/memory_layouts/${inifile}"

    echo "[Dwarf Therapist Wrapper] Fixing Dwarf Fortress MD5 prefix:"
    echo "  Input:   $input_file"
    echo "  Search:  $orig_md5"
    echo "  Output:  $output_file"
    echo "  Replace: $patched_md5"

    substitute "$input_file" "$output_file" --replace "$orig_md5" "$patched_md5"
  '';

  preferLocalBuild = true;
}
