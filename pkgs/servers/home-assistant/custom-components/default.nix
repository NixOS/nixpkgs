{ callPackage
}:

{
  prometheus-sensor = callPackage ./prometheus-sensor {};
  tapo = callPackage ./tapo {};
}
