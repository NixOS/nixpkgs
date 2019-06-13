{ stdenvNoCC, lib, buildEnv, callPackage
, df-games, themes, latestVersion, versionToName
, dfVersion ? latestVersion
  # This package should, at any given time, provide an opinionated "optimal"
  # DF experience. It's the equivalent of the Lazy Newbie Pack, that is, and
  # should contain every utility available unless you disable them.
, enableDFHack ? stdenvNoCC.isLinux
, enableTWBT ? enableDFHack
, enableSoundSense ? true
, enableStoneSense ? true
, enableDwarfTherapist ? true
, enableLegendsBrowser ? true, legends-browser
, theme ? themes.phoebus
# General config options:
, enableIntro ? true
, enableTruetype ? true
, enableFPS ? false
, enableTextMode ? false
}:

with lib;

let
  dfGame = versionToName dfVersion;
  dwarf-fortress = if hasAttr dfGame df-games
                   then getAttr dfGame df-games
                   else throw "Unknown Dwarf Fortress version: ${dfVersion}";
  dwarf-therapist = dwarf-fortress.dwarf-therapist;
in
buildEnv {
  name = "dwarf-fortress-full";
  paths = [
    (dwarf-fortress.override {
      inherit enableDFHack enableTWBT enableSoundSense enableStoneSense theme
              enableIntro enableTruetype enableFPS enableTextMode;
    })]
    ++ lib.optional enableDwarfTherapist dwarf-therapist
    ++ lib.optional enableLegendsBrowser legends-browser;

  meta = with stdenvNoCC.lib; {
    description = "An opinionated wrapper for Dwarf Fortress";
    maintainers = with maintainers; [ Baughn numinit ];
    license = licenses.mit;
    platforms = platforms.all;
    homepage = https://github.com/NixOS/nixpkgs/;
  };
}
