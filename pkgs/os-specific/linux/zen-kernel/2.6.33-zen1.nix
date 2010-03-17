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
      url = "mirror://kernel/linux/kernel/v2.6/linux-2.6.33.tar.bz2";
      sha256 = "1inmam21w13nyf5imgdb5palhiap41zcxf9k32i4ck1w7gg3gqk3";
    };

    kernelPatches = [
      {
         name = "zen4"; 
         patch = runCommand "2.6.33-zen1.patch" {} "${xz}/bin/lzma -d < ${ fetchurl {
	   name = "2.6.33-zen1";
           url = "http://downloads.zen-kernel.org/2.6.33/2.6.33-zen1.patch.lzma";
           sha256 = "0a72d8allr4qi4p6hbbjh33kmcgbg84as0dfb50gsffvaj2d3kwf";
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
      ${if stdenv.lib.attrByPath ["features" "ckSched"] false args then bfsched else forceCFSched}
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
