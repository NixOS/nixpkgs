# Change the HOST/TARGET context of an existing stdenv constructor value.
# Whole-stage bootstrap clearing (package overrides, HOST default inputs) and
# compiler selection belong to the caller.
{
  lib,
  buildPackages,
  hostPlatform,
  targetPlatform ? hostPlatform,
}:
stdenv:
let
  inherit (stdenv) buildPlatform;
  adapt = if hostPlatform.isStatic then buildPackages.stdenvAdapters.makeStatic else lib.id;
in
adapt (
  stdenv.override (old: {
    inherit hostPlatform targetPlatform;
    # The original allowlist describes the original bootstrap closure; it
    # cannot admit the BUILD hooks added below.
    allowedRequisites = null;
    extraNativeBuildInputs =
      (old.extraNativeBuildInputs or [ ])
      ++ lib.optionals (hostPlatform.isLinux && !buildPlatform.isLinux) [ buildPackages.patchelf ]
      ++ lib.optional (
        let
          needsUpdate =
            p:
            !p.isx86
            || builtins.elem p.libc [
              "musl"
              "wasilibc"
              "relibc"
            ]
            || p.isiOS
            || p.isGenode;
        in
        needsUpdate hostPlatform && !(needsUpdate buildPlatform)
      ) buildPackages.updateAutotoolsGnuConfigScriptsHook
      ++ lib.optional (
        hostPlatform.isCygwin && !buildPlatform.isCygwin
      ) buildPackages.cygwin.cygwinDllLinkHook;
  })
)
