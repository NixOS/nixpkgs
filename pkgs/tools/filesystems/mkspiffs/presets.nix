{ stdenv, fetchgit, git }:

let
  buildMkspiffs = overrides : import ./default.nix (
    { inherit stdenv fetchgit git; } // overrides
  );
in

rec {
  arduino-esp32 = buildMkspiffs {
    extraBuildFlags = "-DSPIFFS_OBJ_META_LEN=4";
    buildConfigName = "arduino-esp32";
  };

  esp-idf = buildMkspiffs {
    extraBuildFlags = "-DSPIFFS_OBJ_META_LEN=4";
    buildConfigName = "esp-idf";
  };

  arduino-esp8266 = buildMkspiffs {
    extraBuildFlags = "-DSPIFFS_USE_MAGIC_LENGTH=0 -DSPIFFS_ALIGNED_OBJECT_INDEX_TABLES=1";
    buildConfigName = "arduino-esp8266";
  };
}
