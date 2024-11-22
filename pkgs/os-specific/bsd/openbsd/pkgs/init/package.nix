{
  mkDerivation,
  pathDefinesHook,
  runtimeShell,
}:

mkDerivation {
  path = "sbin/init";
  patches = [ ./no-reset-path.patch ];
  extraNativeBuildInputs = [ pathDefinesHook ];
  PATH_DEFINE__PATH_BSHELL = runtimeShell;
  meta.mainProgram = "init";
}
