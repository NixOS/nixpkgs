{
  stdenvNoCC,
  lib,
  buildEnv,
  df-games,
  themes,
  latestVersion,
  versionToName,
  dfVersion ? latestVersion,
  # This package should, at any given time, provide an opinionated "optimal"
  # DF experience. It's the equivalent of the Lazy Newbie Pack, that is, and
  # should contain every utility available unless you disable them.
  enableDFHack ? stdenvNoCC.hostPlatform.isLinux,
  enableTWBT ? enableDFHack,
  enableSoundSense ? true,
  enableStoneSense ? true,
  enableDwarfTherapist ? true,
  enableLegendsBrowser ? true,
  legends-browser,
  theme ? themes.phoebus,
  # General config options:
  enableIntro ? true,
  enableTruetype ? null, # defaults to 24, see init.txt
  enableFPS ? false,
  enableTextMode ? false,
  enableSound ? true,
}:

let
  inherit (lib)
    getAttr
    hasAttr
    licenses
    maintainers
    optional
    platforms
    ;

  dfGame = versionToName dfVersion;
  dwarf-fortress =
    if hasAttr dfGame df-games then
      getAttr dfGame df-games
    else
      throw "Unknown Dwarf Fortress version: ${dfVersion}";
  dwarf-therapist = dwarf-fortress.dwarf-therapist;

  mainProgram = if enableDFHack then "dfhack" else "dwarf-fortress";
in
buildEnv {
  name = "dwarf-fortress-full";
  paths = [
    (dwarf-fortress.override {
      inherit
        enableDFHack
        enableTWBT
        enableSoundSense
        enableStoneSense
        theme
        enableIntro
        enableTruetype
        enableFPS
        enableTextMode
        enableSound
        ;
    })
  ]
  ++ optional enableDwarfTherapist dwarf-therapist
  ++ optional enableLegendsBrowser legends-browser;

  meta = {
    inherit mainProgram;
    description = "Opinionated wrapper for Dwarf Fortress";
    maintainers = with maintainers; [
      Baughn
      numinit
    ];
    license = licenses.mit;
    platforms = platforms.all;
    homepage = "https://github.com/NixOS/nixpkgs/";
  };
}
