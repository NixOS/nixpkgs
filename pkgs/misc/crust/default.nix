{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, bison
, flex
, buildPackages
}:

let
  defaultVersion = "0.6";

  defaultSrc = fetchFromGitHub {
    owner = "crust-firmware";
    repo = "crust";
    rev = "v${defaultVersion}";
    sha256 = "zalBVP9rI81XshcurxmvoCwkdlX3gMw5xuTVLOIymK4=";
  };

  buildCrust = {
    version ? defaultVersion
  , src ? defaultSrc
  , defconfig
  , extraConfig ? ""
  , extraPatches ? []
  , extraMakeFlags ? []
  , extraMeta ? {}
  , ... } @ args: stdenv.mkDerivation ({
    pname = if (builtins.isNull ((builtins.match "_defconfig$" defconfig)))
      then "crust-${lib.strings.removeSuffix "_defconfig" defconfig}"
      else "crust-${defconfig}";

    inherit version;
    inherit src;

    # Only for global crust patches, per-device paches should be included as extras to avoid adding noise which would complicate debugging
    patches = [] ++ extraPatches;

    postPatch = "";

    nativeBuildInputs = [
      flex
      bison
    ];

    depsBuildBuild = [ buildPackages.stdenv.cc ];

    makeFlags = [
      "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
    ] ++ extraMakeFlags;

    configurePhase = ''
      runHook preConfigure

      echo "Configuring for ${defconfig}"
      make "${defconfig}"

      # The variable 'extraConfigPath' is often parsed as blank resulting in a scenario where `cat` is expecting interactive input followed by line-break to continue, this is to reduce the risk of that happening
      [ -z "$extraConfigPath" ] || {
        cat $extraConfigPath >> .config
      }

      runHook postConfigure
    '';

    # The package has only one output which is located in `build/scp/scp.bin`
    installPhase = ''
      runHook preInstall

      mkdir "$out"
      cp -v "build/scp/scp.bin" "$out/scp.bin"

      runHook postInstall
    '';

    hardeningDisable = [ "all" ];

    # Default Metadata
    meta = with lib; {
      homepage = "https://github.com/crust-firmware/crust";
      description = "SCP (power management) firmware for sunxi SoCs";
      # Project using 3rdparty components https://github.com/crust-firmware/crust/blob/master/LICENSE.md#crust-firmware-licensing
      platforms = [ "or1k-none" ];
      license = with licenses; [
        bsd1
        bsd3
        mit
        gpl2
      ];
    } // extraMeta;
  } // removeAttrs args [ "extraMeta" ]);

in {
  inherit buildCrust;

  # Example configuration:
  ## crustExample = buildCrust {
  ##   defconfig = "example_defconfig";
  ##   extraMeta = {
  ##     description = "SCP (power management) firmware for Example";
  ##     platforms = [ "or1k-none" ];
  ##     maintainers = with lib.maintainers; [ your-usename-here ];
  ##   };
  ## };

  crustOlimexA64Teres1 = buildCrust {
    defconfig = "teres_i_defconfig";
    extraMeta = {
      description = "SCP (power management) firmware for TERES-1";
      maintainers = with lib.maintainers; [ kreyren ];
    };
  };
}
