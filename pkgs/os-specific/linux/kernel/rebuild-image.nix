{
  lib,
  kernel,
}:

{
  target ? kernel.target,
}:

let
  inherit (kernel) stdenv;
in

stdenv.mkDerivation {
  pname = "linux-image";
  inherit (kernel)
    version
    __structuredAttrs
    enableParallelBuilding
    hardeningDisable
    installFlags
    depsBuildBuild
    nativeBuildInputs
    makeFlags
    stripDebugList
    ;

  src = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  buildFlags = [
    target

    # The kernel image targets depend on `vmlinux`, which is a phony
    # target pulling in all the kernel sources and intermediate build
    # outputs. We preserved the necessary files in the original kernel
    # build and don’t want to do the whole thing again, so tell Make to
    # assume that it doesn’t need rebuilding.
    #
    # We need to override `MAKE` here because Make deliberately doesn’t
    # propagate `--assume-old=` to sub‐Makes, and ignores it in
    # `MAKEFLAGS`.
    "MAKE=$(MAKE_COMMAND) --assume-old=vmlinux${lib.optionalString stdenv.hostPlatform.isx86 " --assume-old=vmlinux.unstripped"}"
  ];

  installTargets = [ (kernel.installTargetFor target) ];

  dontConfigure = true;

  env = kernel.env // {
    buildRoot = ".";
  };

  meta = kernel.meta // {
    description = kernel.meta.description + " (image)";
  };
}
