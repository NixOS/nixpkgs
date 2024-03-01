{ callPackage
}:

{
  adaptive_lighting = callPackage ./adaptive_lighting {};

  emporia_vue = callPackage ./emporia_vue {};

  govee-lan = callPackage ./govee-lan {};

  gpio = callPackage ./gpio {};

  localtuya = callPackage ./localtuya {};

  miele = callPackage ./miele {};

  prometheus_sensor = callPackage ./prometheus_sensor {};

  waste_collection_schedule = callPackage ./waste_collection_schedule {};
}
