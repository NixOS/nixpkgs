{ stdenv, fetchFromGitHub, kernel }:

with (import ./srcs.nix { inherit stdenv fetchFromGitHub; });

stdenv.mkDerivation {
  name = "irati-${version}-${kernel.version}";
  inherit version src prePatch meta;

  # https://lkml.org/lkml/2017/11/25/90
  patches = [ ./timer-list-linux-4.15.patch ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  # Define flag for newer kernels, ignore the gcc warnings in this module.
  NIX_CFLAGS_COMPILE = with stdenv.lib; "${optionalString (versionOlder "4.15" kernel.version) "-DHAVE_KERNEL_TIMER_FUNCTION_TIMER_LIST=1"} -w";

  configurePhase = ''
    echo "Creating symbolic links within librina folder"
    (cd librina/src && ln -sf ../../common/ker-numtables.c ker-numtables.c && ln -sf ../../common/serdes-utils.c serdes-utils.c)
    (cd librina/src && mkdir irati && cd irati && ln -sf ../../../include/irati/kucommon.h kucommon.h && ln -sf ../../../include/irati/kernel-msg.h kernel-msg.h && ln -sf ../../../include/irati/serdes-utils.h serdes-utils.h)

    cd kernel
    ./configure --kernbuilddir ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build
    ln -s ../include/irati .
  '';
}
