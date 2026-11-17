{
  lib,
  makeSetupHook,
}:

makeSetupHook {
  name = "freebsd-setup-hook";
  meta.license = lib.licenses.mit;
} ./setup-hook.sh
