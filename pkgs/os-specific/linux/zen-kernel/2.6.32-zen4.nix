args @ {stdenv, fetchurl, xz, runCommand, userModeLinux ? false, extraConfig ? "", 
  kernelPatches ? [], extraMeta ? {}, 
  features ? {}, preConfigure ? "",
  ...}:

let 
  conf = import ../kernel/config-blocks.nix; 

in

import ../kernel/generic.nix (
  rec {
    version = "2.6.32-zen4";

    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v2.6/linux-2.6.32.tar.bz2";
      sha256 = "0kjhnkf2ldivagczs16q49zm2lr3khh01pqrlsc7sh5qh1npi6ah";
    };

    kernelPatches = [
      {
         patch = runCommand "2.6.32-zen4.patch" {} "${xz}/bin/lzma -d < ${ fetchurl {
	   name = "2.6.32-zen4";
           url = "http://downloads.zen-kernel.org/2.6.32/2.6.32-zen4.patch.lzma";
           sha256 = "1dyp9sfigqjfqw1c94010c521bhcy1xnzp91kkhg3dwgzfpsp2k2";
         } } > $out";
      }
    ]
    ++
    stdenv.lib.attrByPath ["kernelPatches"] [] args;

    features = {
      iwlwifi = true;
      zen = true;
      fbConDecor = true;
      aufs = true;
    } // (stdenv.lib.attrByPath ["features"] {} args);

    config = with conf;
    ''
      ${generalOptions}
      ${noDebug}
      ${virtualisation}
      ${if stdenv.lib.attrByPath ["features" "oldI686"] false args then noPAE else ""}
      ${usefulSubsystems}
      ${cfq}
      ${noNUMA}
      ${networking}
      ${wireless}
      ${fb}
      ${fbConDecor}
      ${sound}
      ${usbserial}
      ${fsXattr}
      ${security}
      ${blockDevices}
      ${bluetooth}
      ${misc}
      ${if stdenv.lib.attrByPath ["features" "ckSched"] false args then bfsched else ""}
    '';

    preConfigure = ''
      mv README.zen README-zen
    '' + stdenv.lib.attrByPath ["preConfigure"] "" args;

    extraMeta = {
      maintainers = [stdenv.lib.maintainers.raskin];
      platforms = with stdenv.lib.platforms;
        linux;
    } // stdenv.lib.attrByPath ["extraMeta"] {} args;
  } 
  // removeAttrs args ["extraConfig" "extraMeta" "features" "kernelPatches" 
                        "xz" "runCommand" "preConfigure"]
)
