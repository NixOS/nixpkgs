{ lib, mkAppleDerivation }:

mkAppleDerivation {
  releaseName = "basic_cmds";

  outputs = [
    "out"
    "man"
  ];

  xcodeHash = "sha256-gT7kP/w23d5kGKgNPYS9ydCbeVaLwriMJj0BPIHgQ4U=";

  meta = {
    description = "Basic commands for Darwin";
    license = [
      lib.licenses.isc
      lib.licenses.bsd3
    ];
  };
}
