{ stdenv, symlinkJoin, dwarf-therapist, dwarf-fortress, makeWrapper }:

let
  platformSlug = if stdenv.targetPlatform.is32bit then
    "linux32" else "linux64";
  inifile = "linux/v0.${dwarf-fortress.baseVersion}.${dwarf-fortress.patchVersion}_${platformSlug}.ini";

in symlinkJoin {
  name = "dwarf-therapist-${dwarf-therapist.version}";

  paths = [ dwarf-therapist ];

  buildInputs = [ makeWrapper ];

  passthru = { inherit dwarf-fortress dwarf-therapist; };

  postBuild = ''
    # DwarfTherapist assumes it's run in $out/share/dwarftherapist and
    # therefore uses many relative paths.
    wrapProgram $out/bin/dwarftherapist \
      --run "cd $out/share/dwarftherapist"
    ln -s $out/bin/dwarftherapist $out/bin/DwarfTherapist

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
