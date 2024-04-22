{ mkDerivation
, bsdSetupHook, freebsdSetupHook
, makeMinimal, install, mandoc, groff
}:

mkDerivation {
  path = "usr.bin/tsort";
  nativeBuildInputs =  [
    bsdSetupHook freebsdSetupHook
    makeMinimal install mandoc groff
  ];
}
