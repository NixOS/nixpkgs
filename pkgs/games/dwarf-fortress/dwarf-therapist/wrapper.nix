{ symlinkJoin, lib, dwarf-therapist-original, dwarf-fortress-original, makeWrapper }:

let
  df = dwarf-fortress-original;
  dt = dwarf-therapist-original;
  inifile = "linux/v0.${df.baseVersion}.${df.patchVersion}.ini";
  dfHashFile = "${df}/hash.md5";

in symlinkJoin {
  name = "dwarf-therapist-${dt.version}";

  paths = [ dt ];

  buildInputs = [ makeWrapper ];

  postBuild = ''
    # DwarfTherapist assumes it's run in $out/share/dwarftherapist and
    # therefore uses many relative paths.
    wrapProgram $out/bin/DwarfTherapist \
      --run "cd $out/share/dwarftherapist"

    rm -rf $out/share/dwarftherapist/memory_layouts/linux
    mkdir -p $out/share/dwarftherapist/memory_layouts/linux
    origmd5=$(cat "${dfHashFile}.orig" | cut -c1-8)
    patchedmd5=$(cat "${dfHashFile}" | cut -c1-8)
    substitute \
      ${dt.layouts}/${inifile} \
      $out/share/dwarftherapist/memory_layouts/${inifile} \
      --replace "$origmd5" "$patchedmd5"
  '';
}
