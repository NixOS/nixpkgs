{ pkgs, stdenv, dwarf-therapist, dwarf-fortress, makeWrapper }:

let
  platform = if stdenv.isLinux then "linux" else
               if stdenv.isDarwin then "osx" else
               throw "Invalid platform: must be Linux or Darwin";

  platformSlug = if stdenv.targetPlatform.is32bit then
    "${platform}32" else "${platform}64";

  inifile = "${platform}/v0.${dwarf-fortress.baseVersion}.${dwarf-fortress.patchVersion}_${platformSlug}.ini";
in
stdenv.mkDerivation {
  name = "dwarf-therapist-${dwarf-therapist.version}";
  
  wrapper = ./dwarf-therapist.in;

  paths = [ dwarf-therapist ];

  buildInputs = [ makeWrapper ];

  passthru = { inherit dwarf-fortress dwarf-therapist; };

  buildCommand = ''
    mkdir -p $out/bin

    substitute $wrapper $out/bin/dwarftherapist \
      --subst-var-by stdenv_shell ${stdenv.shell} \
      --subst-var-by install $out \
      --subst-var-by therapist ${dwarf-therapist} \
      --subst-var-by qt_plugin_path "${pkgs.qt5.qtbase}/lib/qt-${pkgs.qt5.qtbase.qtCompatVersion}/plugins/platforms"

    chmod 755 $out/bin/dwarftherapist

    if [ ! -f $out/bin/DwarfTherapist ]; then
      # Case-sensitive filesystem; make a link
      ln -s $out/bin/dwarftherapist $out/bin/DwarfTherapist
    fi

    # Fix up memory layouts
    input_file="${dwarf-therapist}/share/dwarftherapist/memory_layouts/${inifile}"
    output_file="$out/share/dwarftherapist/memory_layouts/${inifile}"

    rm -rf $out/share/dwarftherapist/memory_layouts/${platform}
    mkdir -p $out/share/dwarftherapist/memory_layouts/${platform}
    orig_md5=$(cat "${dwarf-fortress}/hash.md5.orig" | cut -c1-8)
    patched_md5=$(cat "${dwarf-fortress}/hash.md5" | cut -c1-8)

    echo "[Dwarf Therapist Wrapper] Fixing Dwarf Fortress MD5 prefix:"
    echo "  Input:   $input_file"
    echo "  Search:  $orig_md5"
    echo "  Output:  $output_file"
    echo "  Replace: $patched_md5"

    substitute "$input_file" "$output_file" --replace "$orig_md5" "$patched_md5"
  '';

  preferLocalBuild = true;
}
