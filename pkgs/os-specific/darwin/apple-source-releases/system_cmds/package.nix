{
  lib,
  AvailabilityVersions,
  apple-sdk,
  apple-sdk_15,
  libutil,
  mkAppleDerivation,
  ncurses,
  openpam,
  pkg-config,
  stdenv,
  stdenvNoCC,
}:

let
  libdispatch = apple-sdk.sourceRelease "libdispatch"; # Has to match the version of the SDK

  Libc = apple-sdk.sourceRelease "Libc";
  libmalloc = apple-sdk.sourceRelease "libmalloc";
  OpenDirectory = apple-sdk.sourceRelease "OpenDirectory";

  libplatform = apple-sdk.sourceRelease "libplatform";
  xnu = apple-sdk_15.sourceRelease "xnu"; # Needed for `posix_spawn_secflag_options`

  privateHeaders = stdenvNoCC.mkDerivation {
    name = "system_cmds-deps-private-headers";

    buildCommand = ''
      mkdir -p "$out/include/sys"
      '${lib.getExe AvailabilityVersions}' ${lib.getVersion apple-sdk} "$out"

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
        '${xnu}/libsyscall/wrappers/libproc/libproc_private.h' \
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
        '${Libc}/os/variant_private.h' \
        '${xnu}/libkern/os/base_private.h'
      substituteInPlace "$out/include/os/variant_private.h" \
        --replace-fail ', bridgeos(4.0)' "" \
        --replace-fail ', bridgeos' ""
      touch "$out/include/os/feature_private.h"

      install -D -t "$out/include/sys" \
        '${xnu}/bsd/sys/csr.h' \
        '${xnu}/bsd/sys/event_private.h' \
        '${xnu}/bsd/sys/pgo.h' \
        '${xnu}/bsd/sys/kdebug_private.h' \
        '${xnu}/bsd/sys/kern_memorystatus.h' \
        '${xnu}/bsd/sys/proc_info_private.h' \
        '${xnu}/bsd/sys/reason.h' \
        '${xnu}/bsd/sys/resource.h' \
        '${xnu}/bsd/sys/resource_private.h' \
        '${xnu}/bsd/sys/spawn_internal.h' \
        '${xnu}/bsd/sys/stackshot.h'

      cat <<EOF > "$out/include/sys/kdebug.h"
      #pragma once
      #include_next <sys/kdebug.h>
      #include <sys/kdebug_private.h>
      EOF

      cat <<EOF > "$out/include/sys/proc_info.h"
      #pragma once
      #include_next <sys/proc_info.h>
      #include <sys/proc_info_private.h>
      EOF

      # Older source releases depend on CrashReporterClient.h, but it’s not publicly available.
      touch "$out/include/CrashReporterClient.h"
    '';
  };
in
mkAppleDerivation {
  releaseName = "system_cmds";

  xcodeHash = "sha256-gdtn3zNIneZKy6+X0mQ51CFVLNM6JQYLbd/lotG5/Tw=";

  patches = [
    # `posix_spawnattr_set_use_sec_transition_shims_np` is only available on macOS 15.2 or newer.
    # Disable the feature that requires it when running on older systems.
    ./patches/conditionalize-security-transition-shims.patch
  ];

  postPatch = ''
    # Replace hard-coded, impure system paths with the output path in the store.
    sed -e "s|PATH=[^;]*|PATH='$out/bin'|" -i "pagesize/pagesize.sh"

    # Requires BackgroundTaskManagement.framework headers.
    sed -e '/    if (os_feature_enabled(cronBTMToggle, cronBTMCheck))/,/    }/d' -i atrun/atrun.c

    # Fix format security errors
    for src in latency/latency.c sc_usage/sc_usage.c; do
      substituteInPlace $src \
        --replace-fail 'printw(tbuf)' 'printw("%s", tbuf);'
    done
  '';

  preConfigure = ''
    export NIX_CFLAGS_COMPILE+=" -iframework $SDKROOT/System/Library/Frameworks/OpenDirectory.framework/Frameworks"
  '';

  env.NIX_CFLAGS_COMPILE = "-I${privateHeaders}/include";

  buildInputs = [
    apple-sdk.privateFrameworksHook
    libutil
    ncurses
    openpam
  ];

  nativeBuildInputs = [ pkg-config ];

  meta.description = "System commands for Darwin";
}
