{ stdenvNoCC, lib, buildEnv
, dwarf-fortress, themes
  # This package should, at any given time, provide an opinionated "optimal"
  # DF experience. It's the equivalent of the Lazy Newbie Pack, that is, and
  # should contain every utility available.
, enableDFHack ? stdenvNoCC.isLinux
, enableTWBT ? enableDFHack
, enableSoundSense ? true
, enableStoneSense ? false  # StoneSense is currently broken.
, enableDwarfTherapist ? true, dwarf-therapist
, enableLegendsBrowser ? true, legends-browser
, theme ? themes.phoebus
# General config options:
, enableIntro ? true
, enableTruetype ? true
, enableFPS ? false
}:

buildEnv {
  name = "dwarf-fortress-full";
  paths = [
    (dwarf-fortress.override {
      inherit enableDFHack enableTWBT enableSoundSense enableStoneSense theme
              enableIntro enableTruetype enableFPS;
    })]
    ++ lib.optional enableDwarfTherapist dwarf-therapist
    ++ lib.optional enableLegendsBrowser legends-browser;

  meta = with stdenvNoCC.lib; {
    description = "An opinionated wrapper for Dwarf Fortress";
    maintainers = with maintainers; [ Baughn ];
    license = licenses.mit;
    platforms = platforms.all;
    homepage = https://github.com/NixOS/nixpkgs/;
  };
}
