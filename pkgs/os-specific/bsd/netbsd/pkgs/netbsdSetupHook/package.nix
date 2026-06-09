{
  lib,
  makeSetupHook,
}:

makeSetupHook {
  name = "netbsd-setup-hook";
  meta.license = lib.licenses.mit;
} ./setup-hook.sh
