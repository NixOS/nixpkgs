{ mkKaemDerivation0
, mescc-tools-extra-src
, mescc-tools
, version
}:
mkKaemDerivation0 {
  name = "mescc-tools-extra-${version}";
  script = ./build.kaem;

  src = mescc-tools-extra-src;
  inherit mescc-tools;
}
