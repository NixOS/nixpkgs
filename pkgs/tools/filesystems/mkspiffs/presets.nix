{ lib, mkspiffs }:

# We provide the same presets as the upstream

lib.mapAttrs (
  name: { CPPFLAGS }:
<<<<<<< HEAD
  mkspiffs.overrideAttrs {
    inherit CPPFLAGS;
    BUILD_CONFIG_NAME = "-${name}";
  }
=======
  mkspiffs.overrideAttrs (drv: {
    inherit CPPFLAGS;
    BUILD_CONFIG_NAME = "-${name}";
  })
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
) {
  arduino-esp8266.CPPFLAGS = [
    "-DSPIFFS_USE_MAGIC_LENGTH=0"
    "-DSPIFFS_ALIGNED_OBJECT_INDEX_TABLES=1"
  ];

  arduino-esp32.CPPFLAGS = [ "-DSPIFFS_OBJ_META_LEN=4" ];

  esp-idf.CPPFLAGS = [ "-DSPIFFS_OBJ_META_LEN=4" ];
}
