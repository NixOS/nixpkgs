# make sure to use NON EXISTING kernel settings else they may conflict with
# common-config.nix
{ lib, pkgs }:

let
  lts_kernel = pkgs.linuxPackages.kernel;

  # to see the result once the module transformed the lose structured config
  getConfig =
    structuredConfig:
    (lts_kernel.override {
      structuredExtraConfig = structuredConfig;
    }).configfile.structuredConfig;

  mandatoryVsOptionalConfig = lib.mkMerge [
    { NIXOS_FAKE_USB_DEBUG = lib.kernel.yes; }
    { NIXOS_FAKE_USB_DEBUG = lib.kernel.option lib.kernel.yes; }
  ];

  freeformConfig = lib.mkMerge [
    { NIXOS_FAKE_MMC_BLOCK_MINORS = lib.kernel.freeform "32"; } # same as default, won't trigger any error
    { NIXOS_FAKE_MMC_BLOCK_MINORS = lib.kernel.freeform "64"; } # will trigger an error but the message is not great:
  ];

  mkDefaultWorksConfig = lib.mkMerge [
    { "NIXOS_TEST_BOOLEAN" = lib.kernel.yes; }
    { "NIXOS_TEST_BOOLEAN" = lib.mkDefault lib.kernel.no; }
  ];

  allOptionalRemainOptional = lib.mkMerge [
    { NIXOS_FAKE_USB_DEBUG = lib.kernel.option lib.kernel.yes; }
    { NIXOS_FAKE_USB_DEBUG = lib.kernel.option lib.kernel.yes; }
  ];

  failures = lib.runTests {
    testEasy = {
      expr = (getConfig { NIXOS_FAKE_USB_DEBUG = lib.kernel.yes; }).NIXOS_FAKE_USB_DEBUG;
      expected = {
        tristate = "y";
        optional = false;
        freeform = null;
      };
    };

    # mandatory flag should win over optional
    testMandatoryCheck = {
      expr = (getConfig mandatoryVsOptionalConfig).NIXOS_FAKE_USB_DEBUG.optional;
      expected = false;
    };

    testYesWinsOverNo = {
      expr = (getConfig mkDefaultWorksConfig)."NIXOS_TEST_BOOLEAN".tristate;
      expected = "y";
    };

    testAllOptionalRemainOptional = {
      expr = (getConfig allOptionalRemainOptional)."NIXOS_FAKE_USB_DEBUG".optional;
      expected = true;
    };

    # check that freeform options are unique
    # Should trigger
    # > The option `settings.NIXOS_FAKE_MMC_BLOCK_MINORS.freeform' has conflicting definitions, in `<unknown-file>' and `<unknown-file>'
    testTreeform =
      let
        res = builtins.tryEval ((getConfig freeformConfig).NIXOS_FAKE_MMC_BLOCK_MINORS.freeform);
      in
      {
        expr = res.success;
        expected = false;
      };

  };
in

lib.optional (failures != [ ]) (
  throw "The following kernel unit tests failed: ${lib.generators.toPretty { } failures}"
)
