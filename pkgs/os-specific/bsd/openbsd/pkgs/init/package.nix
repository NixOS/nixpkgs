{
  lib,
  mkDerivation,
  runtimeShell,
}:
mkDerivation {
  path = "sbin/init";

  postPatch = ''
    substituteInPlace "$BSDSRCDIR/sbin/init/pathnames.h" \
      --replace-fail '#include <paths.h>' \
        $'#include <paths.h>\n\n#undef _PATH_BSHELL\n#define _PATH_BSHELL "${runtimeShell}"'
    substituteInPlace "$BSDSRCDIR/sbin/init/init.c" \
      --replace-fail '	setenv("PATH", _PATH_STDPATH, 1);' ""
  '';

  meta = {
    description = "OpenBSD system initialization process";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "init";
    platforms = lib.platforms.openbsd;
  };
}
