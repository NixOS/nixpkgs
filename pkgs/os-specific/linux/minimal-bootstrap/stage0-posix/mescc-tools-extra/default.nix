{ mkKaemDerivation0
, src
, mescc-tools
, version
}:
mkKaemDerivation0 {
  name = "mescc-tools-extra-${version}";
  script = ./build.kaem;

  inherit src mescc-tools;
}
