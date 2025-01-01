{
  lib,
  apple-sdk,
  apple-sdk_12,
  mkAppleDerivation,
  ncurses,
  openpam,
  pkg-config,
  stdenv,
  stdenvNoCC,
}:

let
  libdispatch = apple-sdk.sourceRelease "libdispatch"; # Has to match the version of the SDK

  Libc = apple-sdk_12.sourceRelease "Libc";
  libmalloc = apple-sdk_12.sourceRelease "libmalloc";
  OpenDirectory = apple-sdk_12.sourceRelease "OpenDirectory";

  libplatform = apple-sdk_12.sourceRelease "libplatform";
  xnu = apple-sdk_12.sourceRelease "xnu";

  privateHeaders = stdenvNoCC.mkDerivation {
    name = "system_cmds-deps-private-headers";

    buildCommand = ''
      install -D -t "$out/include/CFOpenDirectory" \
        '${OpenDirectory}/Core/CFOpenDirectoryPriv.h' \
        '${OpenDirectory}/Core/CFODTrigger.h'
      touch "$out/include/CFOpenDirectory/CFOpenDirectoryConstantsPriv.h"

      install -D -t "$out/include/IOKit" \
        '${xnu}/iokit/IOKit/IOKitKeysPrivate.h'

      install -D -t "$out/include/OpenDirectory" \
        '${OpenDirectory}/Framework/OpenDirectoryPriv.h' \
        '${OpenDirectory}/Framework/NSOpenDirectoryPriv.h'

      install -D -t "$out/include/System/sys" \
        '${xnu}/bsd/sys/proc.h' \
        '${xnu}/bsd/sys/proc_uuid_policy.h'

      install -D -t "$out/include" \
        '${libmalloc}/private/stack_logging.h' \
        '${libplatform}/private/_simple.h' \
        '${xnu}/libsyscall/wrappers/spawn/spawn_private.h'
      touch "$out/include/btm.h"

      cp -r '${libdispatch}/private' "$out/include/dispatch"
      # Work around availability headers compatibility issue when building with an unprocessed SDK.
      chmod -R u+w "$out/include/dispatch"
      find "$out/include/dispatch" -name '*.h' -exec sed -i {} -e 's/, bridgeos([^)]*)//g' \;

      install -D -t "$out/include/System/i386" \
        '${xnu}/osfmk/i386/cpu_capabilities.h'

      install -D -t "$out/include/kern" \
        '${xnu}/osfmk/kern/debug.h'

      install -D -t "$out/include/mach" \
        '${xnu}/osfmk/mach/coalition.h'

      install -D -t "$out/include/os" \
        '${Libc}/os/assumes.h' \
        '${xnu}/libkern/os/base_private.h'
      touch "$out/include/os/feature_private.h"

      install -D -t "$out/include/sys" \
        '${xnu}/bsd/sys/csr.h' \
        '${xnu}/bsd/sys/pgo.h' \
        '${xnu}/bsd/sys/kern_memorystatus.h' \
        '${xnu}/bsd/sys/reason.h' \
        '${xnu}/bsd/sys/resource.h' \
        '${xnu}/bsd/sys/spawn_internal.h' \
        '${xnu}/bsd/sys/stackshot.h'

      # Older source releases depend on CrashReporterClient.h, but it’s not publicly available.
      touch "$out/include/CrashReporterClient.h"
    '';
  };
in
mkAppleDerivation {
  releaseName = "system_cmds";

  xcodeHash = "sha256-gdtn3zNIneZKy6+X0mQ51CFVLNM6JQYLbd/lotG5/Tw=";

  postPatch = ''
    # Replace hard-coded, impure system paths with the output path in the store.
    sed -e "s|PATH=[^;]*|PATH='$out/bin'|" -i "pagesize/pagesize.sh"

    # Requires BackgroundTaskManagement.framework headers.
    sed -e '/    if (os_feature_enabled(cronBTMToggle, cronBTMCheck))/,/    }/d' -i atrun/atrun.c
  '';

  preConfigure = ''
    export NIX_CFLAGS_COMPILE+=" -iframework $SDKROOT/System/Library/Frameworks/OpenDirectory.framework/Frameworks"
  '';

  env.NIX_CFLAGS_COMPILE = "-I${privateHeaders}/include";

  buildInputs = [
    apple-sdk.privateFrameworksHook
    ncurses
    openpam
  ];

  nativeBuildInputs = [ pkg-config ];

  mesonFlags = [ (lib.mesonOption "sdk_version" stdenv.hostPlatform.darwinSdkVersion) ];

  meta.description = "System commands for Darwin";
}
