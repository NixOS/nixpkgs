{
  lib,
  makeSetupHook,
  python3,
  python3Packages,
  bash,
}:
makeSetupHook {
  name = "satyrographosInstallHook";

  passthru.provides.setupHook = true;

  propagatedBuildInputs = [
    python3
    python3Packages.sexpdata
  ];

  substitutions = {
    shell = "${bash}/bin/bash";
  };

  meta = {
    description = "Install hook for Satyrographos";
    maintainers = with lib.maintainers; [ momeemt ];
  };
} ./satyrographos-install-hook.sh

