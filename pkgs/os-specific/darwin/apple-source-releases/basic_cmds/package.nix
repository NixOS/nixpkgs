{ lib, mkAppleDerivation }:

mkAppleDerivation {
  releaseName = "basic_cmds";

  outputs = [
    "out"
    "man"
  ];

  xcodeHash = "sha256-gT7kP/w23d5kGKgNPYS9ydCbeVaLwriMJj0BPIHgQ4U=";

  meta = with lib; {
    description = "Basic commands for Darwin";
    license = [
      licenses.isc
      licenses.bsd3
    ];
  };
}
