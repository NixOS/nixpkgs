{ callPackage
}:

{
  adaptive_lighting = callPackage ./adaptive_lighting {};

  govee-lan = callPackage ./govee-lan {};

  gpio = callPackage ./gpio {};

  miele = callPackage ./miele {};

  prometheus_sensor = callPackage ./prometheus_sensor {};

  waste_collection_schedule = callPackage ./waste_collection_schedule {};
}
