# DAW plugins
# ===========
#
# This file contains various DAW plugins, e.g. those for LV2.
#

{ lib, pkgs }:

lib.makeExtensible (self: with self; let

  callPackage = pkgs.newScope self;

in {

  inherit callPackage;

  CharacterCompressor = callPackage ../applications/audio/magnetophonDSP/CharacterCompressor { };
  CompBus = callPackage ../applications/audio/magnetophonDSP/CompBus { };
  ConstantDetuneChorus  = callPackage ../applications/audio/magnetophonDSP/ConstantDetuneChorus { };
  faustCompressors =  callPackage ../applications/audio/magnetophonDSP/faustCompressors { };
  LazyLimiter = callPackage ../applications/audio/magnetophonDSP/LazyLimiter { };
  MBdistortion = callPackage ../applications/audio/magnetophonDSP/MBdistortion { };
  pluginUtils = callPackage ../applications/audio/magnetophonDSP/pluginUtils  { };
  RhythmDelay = callPackage ../applications/audio/magnetophonDSP/RhythmDelay { };
  VoiceOfFaust = callPackage ../applications/audio/magnetophonDSP/VoiceOfFaust { };
  shelfMultiBand = callPackage ../applications/audio/magnetophonDSP/shelfMultiBand  { };

  ams-lv2 = callPackage ../applications/audio/ams-lv2 { };

  eteroj.lv2 = libsForQt5.callPackage ../applications/audio/eteroj.lv2 { };

  gxmatcheq-lv2 = callPackage ../applications/audio/gxmatcheq-lv2 { };

  gxplugins-lv2 = callPackage ../applications/audio/gxplugins-lv2 { };

  ir.lv2 = callPackage ../applications/audio/ir.lv2 { };

  mda_lv2 = callPackage ../applications/audio/mda-lv2 { };

  metersLv2 = callPackage ../applications/audio/meters_lv2 { };

  rkrlv2 = callPackage ../applications/audio/rkrlv2 {};

  sisco.lv2 = callPackage ../applications/audio/sisco.lv2 { };

  swh_lv2 = callPackage ../applications/audio/swh-lv2 { };

})