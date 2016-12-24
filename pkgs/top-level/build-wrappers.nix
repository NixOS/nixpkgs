# Build-time wrapers referencing run-time packages
#
# There are a few simple rules on deps that apply to the vast majority of
# packages: packages used at build-time are native, packages used at run-time
# are foreign, a run-time dep of a build-time dep is a transative build-time
# dep. The overal principle here is a run-time dep is a same phase/stage dep,
# while a build-time dep is a previous phase/stage dep; a package should never
# depend on a future phase/stage.
#
# The glaring exception to this is certain wrappers around build tools
# (especially compilers) that inject run-time dependencies into the artifacts
# these tools create. The inject dependencies belong in a future stage than the
# wrapped tool or the wrapper script, as they are run-time with respect to the
# artifacts built by the tool, not the tool itself.
#
# Where possible, its best to avoid the need for such wrappers, but this cannot
# always be readily accomplished, hence the purpose of this package
# index. `__targetPackages` is the future stage from which to drawn these
# downstream dependencies. Care must be taken to avoid cycles--i.e. use
# unwrapped or less-wrapped version of the tools when building the packages that
# are then injected here.
#
# As an added bonus, since these wrappers are only available as part of
# `buidlPackages`, it will be slightly harder to accidently depend on compilers
# at runtime, which is usually a mistake.
self: super:

with self;

{
  wrapCCWith = ccWrapper: libc: extraBuildCommands: baseCC: ccWrapper {
    nativeTools = stdenv.cc.nativeTools or false;
    nativeLibc = stdenv.cc.nativeLibc or false;
    nativePrefix = stdenv.cc.nativePrefix or "";
    cc = baseCC;
    dyld = if stdenv.isDarwin then darwin.dyld else null;
    isGNU = baseCC.isGNU or false;
    isClang = baseCC.isClang or false;
    inherit libc extraBuildCommands;
  };

  ccWrapperFun = callPackage ../build-support/cc-wrapper;

  wrapCC = wrapCCWith ccWrapperFun __targetPackages.libc "";
  # legacy version, used for gnat bootstrapping
  wrapGCC-old = baseGCC: callPackage ../build-support/gcc-wrapper-old {
    nativeTools = stdenv.cc.nativeTools or false;
    nativeLibc = stdenv.cc.nativeLibc or false;
    nativePrefix = stdenv.cc.nativePrefix or "";
    gcc = baseGCC;
    libc = glibc;
  };

  wrapGCCCross =
    {gcc, libc, binutils, cross, shell ? "", name ? "gcc-cross-wrapper"}:

    callPackage ../build-support/gcc-cross-wrapper {
      nativeTools = false;
      nativeLibc = false;
      noLibc = (libc == null);
      inherit gcc binutils libc shell name cross;
    };

  gccCrossStageStatic = assert stdenv ? cross; wrapGCCCross {
    gcc = gccCrossStageStatic-unwrapped;
    libc = libcTarget;
    inherit binutils;
    inherit (stdenv) cross;
  };

  # Only needed for mingw bootstrapping
  gccCrossMingw2 = assert stdenv ? cross; wrapGCCCross {
    gcc = gccCrossStageStatic-unwrapped;
    libc = windows.mingw_headers2;
    inherit binutils;
    inherit (stdenv) cross;
  };

  gccCrossStageFinal = assert stdenv ? cross; wrapGCCCross {
    gcc = gccCrossStageFinal-unwrapped;
    inherit (__targetPackages) libc;
    inherit binutils;
    inherit (stdenv) cross;
  };

  gcc45 = wrapCC gcc45-unwrapped;
  gcc48 = wrapCC gcc48-unwrapped;
  gcc49 = wrapCC gcc49-unwrapped;
  gcc5 = wrapCC gcc5-unwrapped;
  gcc6 = wrapCC gcc6-unwrapped;
  gcc = wrapCC gcc-unwrapped;

  gcc_debug = wrapCC gcc_debug-unwrapped;

  gfortran48 = wrapCC gfortran48-unwrapped;
  gfortran49 = wrapCC gfortran49-unwrapped;
  gfortran5 = wrapCC gfortran5-unwrapped;
  gfortran6 = wrapCC gfortran6-unwrapped;

  gcj49 = wrapCC gcj49-unwrapped;
  gcj = wrapCC gcj-unwrapped;

  gnat45 = wrapCC gnat45-unwrapped;
  gnat = wrapCC gnat-unwrapped;

  gnatboot = wrapGCC-old  gnatboot-unwrapped;

  gccgo49 = wrapCC gccgo49-unwrapped;
  gccgo = wrapCC gccgo-unwrapped;

  clang_35 = wrapCC llvmPackages_35.clang;
  clang_34 = wrapCC llvmPackages_34.clang;
}
