{ callPackage
}:

{
  adaptive_lighting = callPackage ./adaptive_lighting {};
  miele = callPackage ./miele {};
  prometheus_sensor = callPackage ./prometheus_sensor {};
}
