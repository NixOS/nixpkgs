{
  lib,
  stdenv,
  writeText,
  dwarf-therapist,
  dwarf-fortress,
  dfhack,
  mkDfWrapper,
  replaceVars,
  coreutils,
  wrapQtAppsHook,
  expect,
  xvfb-run,
}:

let
  platformSlug =
    let
      prefix = if dwarf-fortress.baseVersion >= 50 then "-classic_" else "_";
      base = if stdenv.hostPlatform.is32bit then "linux32" else "linux64";
    in
    prefix + base;
  inifile = "linux/v0.${toString dwarf-fortress.baseVersion}.${dwarf-fortress.patchVersion}${platformSlug}.ini";
  unsupportedVersion = lib.versionOlder dwarf-therapist.maxDfVersion dwarf-fortress.dfVersion;

  # Used to run dfhack to produce a Therapist ini file for the current memory map.
  # See: http://www.bay12forums.com/smf/index.php?topic=168411.msg8532557#msg8532557
  dfHackExpectScript = writeText "dfhack.exp" ''
    spawn xvfb-run dfhack +devel/export-dt-ini
    expect "DFHack is ready. Have a nice day!"
    send "die\r"
  '';

  dfHackWrapper = mkDfWrapper {
    inherit dwarf-fortress dfhack;
    enableDFHack = true;
  };
in

stdenv.mkDerivation {
  pname = "dwarf-therapist";
  inherit (dwarf-therapist) version meta maxDfVersion;
  inherit (dwarf-fortress) dfVersion;

  wrapper = replaceVars ./dwarf-therapist.in {
    stdenv_shell = "${stdenv.shell}";
    rm = "${coreutils}/bin/rm";
    ln = "${coreutils}/bin/ln";
    cat = "${coreutils}/bin/cat";
    mkdir = "${coreutils}/bin/mkdir";
    dirname = "${coreutils}/bin/dirname";
    therapist = "${dwarf-therapist}";
    # replaced in buildCommand
    install = null;
  };

  paths = [ dwarf-therapist ];

  nativeBuildInputs = [
    wrapQtAppsHook
  ]
  ++ lib.optionals unsupportedVersion [
    expect
    xvfb-run
    dfHackWrapper
  ];

  passthru = { inherit dwarf-fortress dwarf-therapist; };

  buildCommand =
    lib.optionalString unsupportedVersion ''
      fixupMemoryMaps() (
        local output="$1"
        local orig_md5="$2"
        local patched_md5="$3"
        echo "It doesn't support DF $dfVersion out of the box, so we're doing it the hard way."
        export HOME="$(mktemp -dt dfhack.XXXXXX)"
        export XDG_DATA_HOME="$HOME/.local/share"
        expect ${dfHackExpectScript}
        local ini="$XDG_DATA_HOME/df_linux/therapist.ini"
        if [ -f "$ini" ]; then
          if grep -q "$patched_md5" "$ini"; then
            cp -v "$ini" "$output"
          else
            echo "Couldn't find MD5 ($patched_md5) in $ini"
            exit 1
          fi
        else
          echo "Couldn't find $ini!"
          exit 1
        fi
      )
    ''
    + lib.optionalString (!unsupportedVersion) ''
      fixupMemoryMaps() {
        echo "It should support DF $dfVersion, but we couldn't find any memory maps."
        echo "This is a nixpkgs bug, please report it!"
        exit 1
      }
    ''
    + ''
      mkdir -p $out/bin

      install -Dm755 $wrapper $out/bin/dwarftherapist
      ln -s $out/bin/dwarftherapist $out/bin/DwarfTherapist

      substituteInPlace $out/bin/dwarftherapist \
        --subst-var-by install $out
      wrapQtApp $out/bin/dwarftherapist

      # Fix up memory layouts
      input_file="${dwarf-therapist}/share/dwarftherapist/memory_layouts/${inifile}"
      output_file="$out/share/dwarftherapist/memory_layouts/${inifile}"
      rm -f "$output_file"
      mkdir -p "$(dirname -- "$output_file")"

      orig_md5=$(cat "${dwarf-fortress}/hash.md5.orig" | cut -c1-8)
      patched_md5=$(cat "${dwarf-fortress}/hash.md5" | cut -c1-8)

      if [ -f "$input_file" ]; then
        echo "[Dwarf Therapist Wrapper] Fixing Dwarf Fortress MD5 prefix:"
        echo "  Input:   $input_file"
        echo "  Search:  $orig_md5"
        echo "  Output:  $output_file"
        echo "  Replace: $patched_md5"

        substitute "$input_file" "$output_file" --replace-fail "$orig_md5" "$patched_md5"
      else
        echo "[Dwarf Therapist Wrapper] OH NO! No memory maps found!"
        echo "This version of Therapist ($dfVersion) has max DF version $maxDfVersion."
        fixupMemoryMaps "$output_file" "$orig_md5" "$patched_md5"
      fi
    '';

}
