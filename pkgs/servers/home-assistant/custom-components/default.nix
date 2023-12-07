{ callPackage
}:

{
  miele = callPackage ./miele {};
  prometheus_sensor = callPackage ./prometheus_sensor {};
}
