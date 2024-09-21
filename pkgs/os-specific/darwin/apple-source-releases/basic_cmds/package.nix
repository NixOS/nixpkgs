{ lib, mkAppleDerivation }:

mkAppleDerivation {
  releaseName = "basic_cmds";

  outputs = [
    "out"
    "man"
  ];

  xcodeHash = "sha256-c1qADIrlwWCvKHPa1/s8jW1Eo+7RT8y7yExYNifFF3s=";

  meta = {
    description = "Basic commands for Darwin";
    license = [
      lib.licenses.isc
      lib.licenses.bsd3
    ];
  };
}
