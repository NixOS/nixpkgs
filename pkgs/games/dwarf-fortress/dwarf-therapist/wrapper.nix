{ buildEnv, lib, dwarf-therapist-original, dwarf-fortress-original, makeWrapper }:

let
  df = dwarf-fortress-original;
  dt = dwarf-therapist-original;
  inifile = "linux/v0${df.baseVersion}.${df.patchVersion}.ini";
  dfHashFile = "${df}/hash.md5";

in buildEnv {
  name = "dwarf-therapist-${lib.getVersion dt}";

  paths = [ dt ];

  buildInputs = [ makeWrapper ];

  postBuild = ''
    # DwarfTherapist assumes it's run in $out/share/dwarftherapist and
    # therefore uses many relative paths.
    rm $out/bin
    mkdir $out/bin
    makeWrapper ${dt}/bin/DwarfTherapist $out/bin/DwarfTherapist \
      --run "cd $out/share/dwarftherapist"

    # Fix checksum of memory access directives. We really need #4621 fixed!
    recreate_dir() {
      rm "$out/$1"
      mkdir -p "$out/$1"
      for i in "${dt}/$1/"*; do
        ln -s "$i" "$out/$1"
      done
    }

    recreate_dir share
    recreate_dir share/dwarftherapist
    mkdir -p $out/share/dwarftherapist/memory_layouts/linux
    origmd5=$(cat "${dfHashFile}.orig" | cut -c1-8)
    patchedmd5=$(cat "${dfHashFile}" | cut -c1-8)
    substitute \
      ${dt.layouts}/${inifile} \
      $out/share/dwarftherapist/memory_layouts/${inifile} \
      --replace "$origmd5" "$patchedmd5"
  '';
}
