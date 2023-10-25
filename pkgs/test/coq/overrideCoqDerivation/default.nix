{ lib, coq, mkCoqPackages, runCommand }:

let

  # This is just coq, but with dontFilter set to true. We need to set
  # dontFilter to true here so that _all_ packages are visibile in coqPackages.
  # There may be some versions of the top-level coq and coqPackages that don't
  # build QuickChick, which is what we are using for this test below.
  coqWithAllPackages = coq // { dontFilter = true; };

  coqPackages = mkCoqPackages coqWithAllPackages;

  # This is the main test.  This uses overrideCoqDerivation to
  # override arguments to mkCoqDerivation.
  #
  # Here, we override the defaultVersion and release arguments to
  # mkCoqDerivation.
  overriddenQuickChick =
    coqPackages.lib.overrideCoqDerivation
      {
        defaultVersion = "9999";
        release."9999".sha256 = lib.fakeSha256;
      }
      coqPackages.QuickChick;
in

runCommand
  "coq-overrideCoqDerivation-test-0.1"
  { meta.maintainers = with lib.maintainers; [cdepillabout]; }
  ''
    # Confirm that the computed version number for the overridden QuickChick does
    # actually become 9999, as set above.
    if [ "${overriddenQuickChick.version}" -eq "9999" ]; then
      echo "overriddenQuickChick version was successfully set to 9999"
      touch $out
    else
      echo "ERROR: overriddenQuickChick version was supposed to be 9999, but was actually: ${overriddenQuickChick.version}"
      exit 1
    fi
  ''
