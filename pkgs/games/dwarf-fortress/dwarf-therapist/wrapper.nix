{ stdenv, dwarf-therapist, dwarf-fortress, substituteAll, coreutils, wrapQtAppsHook }:

let
  platformSlug =
    if stdenv.targetPlatform.is32bit then
      "linux32" else "linux64";
  inifile = "linux/v0.${dwarf-fortress.baseVersion}.${dwarf-fortress.patchVersion}_${platformSlug}.ini";

in

stdenv.mkDerivation {
  pname = "dwarf-therapist";
  version = dwarf-therapist.version;

  wrapper = substituteAll {
    src = ./dwarf-therapist.in;
    stdenv_shell = "${stdenv.shell}";
    rm = "${coreutils}/bin/rm";
    ln = "${coreutils}/bin/ln";
    cat = "${coreutils}/bin/cat";
    mkdir = "${coreutils}/bin/mkdir";
    dirname = "${coreutils}/bin/dirname";
    therapist = "${dwarf-therapist}";
  };

  paths = [ dwarf-therapist ];

  nativeBuildInputs = [ wrapQtAppsHook ];

  passthru = { inherit dwarf-fortress dwarf-therapist; };

  buildCommand = ''
    mkdir -p $out/bin

    install -Dm755 $wrapper $out/bin/dwarftherapist
    ln -s $out/bin/dwarftherapist $out/bin/DwarfTherapist

    substituteInPlace $out/bin/dwarftherapist \
      --subst-var-by install $out
    wrapQtApp $out/bin/dwarftherapist

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
