{ callPackage
}:

{
  adaptive_lighting = callPackage ./adaptive_lighting {};

  govee-lan = callPackage ./govee-lan {};

  miele = callPackage ./miele {};

  prometheus_sensor = callPackage ./prometheus_sensor {};
}
