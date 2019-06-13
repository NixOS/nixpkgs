{ stdenv, lib, pkgs }:

with lib.kernel;
with lib.asserts;
with lib.modules;

# To test nixos/modules/system/boot/kernel_config.nix;
let
  # copied from release-lib.nix
  assertTrue = bool:
    if bool
    then pkgs.runCommand "evaluated-to-true" {} "touch $out"
    else pkgs.runCommand "evaluated-to-false" {} "false";

  lts_kernel = pkgs.linuxPackages.kernel;

  kernelTestConfig = structuredConfig: (lts_kernel.override {
    structuredExtraConfig = structuredConfig;
  }).configfile.structuredConfig;

  mandatoryVsOptionalConfig = mkMerge [
    { USB_DEBUG = option yes;}
    { USB_DEBUG = yes;}
  ];

  freeformConfig = mkMerge [
    { MMC_BLOCK_MINORS = freeform "32"; } # same as default, won't trigger any error
    { MMC_BLOCK_MINORS = freeform "64"; } # will trigger an error but the message is not great:
  ];

  yesWinsOverNoConfig = mkMerge [
    # default for "8139TOO_PIO" is no
    { "8139TOO_PIO"  = yes; } # yes wins over no by default
    { "8139TOO_PIO"  = no; }
  ];
in
{
  # mandatory flag should win over optional
  mandatoryCheck = (kernelTestConfig mandatoryVsOptionalConfig);

  # check that freeform options are unique
  # Should trigger
  # > The option `settings.MMC_BLOCK_MINORS.freeform' has conflicting definitions, in `<unknown-file>' and `<unknown-file>'
  freeformCheck = let
    res = builtins.tryEval ( (kernelTestConfig freeformConfig).MMC_BLOCK_MINORS.freeform);
  in
    assertTrue (res.success == false);

  yesVsNoCheck = let
    res = kernelTestConfig yesWinsOverNoConfig;
  in
    assertTrue (res."8139TOO_PIO".tristate == "y");
}
