{
  lib,
  makeSetupHook,
}:

makeSetupHook {
  name = "openbsd-setup-hook";
  meta.license = lib.licenses.mit;
} ./setup-hook.sh
