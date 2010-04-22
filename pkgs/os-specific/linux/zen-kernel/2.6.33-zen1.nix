args @ {stdenv, fetchurl, xz, runCommand, userModeLinux ? false, extraConfig ? "", 
  kernelPatches ? [], extraMeta ? {}, 
  features ? {}, preConfigure ? "",
  ...}:

let 
  conf = import ../kernel/config-blocks.nix; 

  baseKernelVersion = "2.6.33";
  ZenSuffix = "zen1";

in

import ../kernel/generic.nix (
  rec {
    version = "${baseKernelVersion}-${ZenSuffix}";

    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v2.6/linux-${baseKernelVersion}.tar.bz2";
      sha256 = "1inmam21w13nyf5imgdb5palhiap41zcxf9k32i4ck1w7gg3gqk3";
    };

    kernelPatches = [
      {
         name = "${ZenSuffix}"; 
         patch = runCommand "${baseKernelVersion}-${ZenSuffix}.patch" {} "${xz}/bin/lzma -d < ${ fetchurl {
	   name = "${baseKernelVersion}-${ZenSuffix}.patch.lzma";
           url = "http://downloads.zen-kernel.org/${baseKernelVersion}/${baseKernelVersion}-${ZenSuffix}.patch.lzma";
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
