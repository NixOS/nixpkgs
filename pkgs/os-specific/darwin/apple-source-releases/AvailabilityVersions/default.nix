{
  lib,
  stdenvNoCC,
  appleDerivation',
  gnused,
  python3,
  unifdef,
}:

appleDerivation' stdenvNoCC {
  nativeBuildInputs = [ unifdef ];

  patches = [ ./0001-Support-setting-an-upper-bound-on-versions.patch ];

  buildPhase = ''
    runHook preBuild

    declare -a unifdef_sources=(
      os_availability.modulemap
      os_availability_private.modulemap
      AvailabilityPrivate.modulemap
    )
    unifdef -x2 -UBUILD_FOR_DRIVERKIT -m $(for x in "''${unifdef_sources[@]}"; do echo templates/$x; done)

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/libexec" "$out/share/availability"

    cp -r availability.dsl templates "$out/share/availability/"

    substitute availability "$out/libexec/availability" \
      --replace-fail '/usr/bin/env python3' '${lib.getBin python3}/bin/python3' \
      --replace-fail 'f"{os.path.abspath(os.path.dirname(sys.argv[0]))}/' "\"$out/share/availability/"
    chmod a+x "$out/libexec/availability"

    cat <<SCRIPT > "$out/bin/gen-headers"
    #!/usr/bin/env bash
    set -eu

    declare -a headers=(
      Availability.h
      AvailabilityInternal.h
      AvailabilityInternalLegacy.h
      AvailabilityMacros.h
      AvailabilityVersions.h
      os/availability.h
    )

    dest=\$2
    threshold=\$1

    for header in "\''${headers[@]}"; do
      header_src=\''${header/\//_}
      mkdir -p "\$(dirname "\$dest/include/\$header")"
      "$out/libexec/availability" \\
        --threshold "\$threshold" \\
        --preprocess "$out/share/availability/templates/\$header_src" "\$dest/include/\$header"
    done

    # `__ENVIRONMENT_OS_VERSION_MIN_REQUIRED__` is only defined by clang 17+, so define it for older versions.
    ${lib.getExe gnused} -E '/#ifndef __MAC_OS_X_VERSION_MIN_REQUIRED/{
        i#ifndef __ENVIRONMENT_OS_VERSION_MIN_REQUIRED__
        i#define __ENVIRONMENT_OS_VERSION_MIN_REQUIRED__ __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__
        i#endif
      }' \\
      -i "\$dest/include/AvailabilityInternal.h"

    # Remove macros from newer SDKs because they can confuse some programs about the SDK version.
    declare -a versionParts=(\''${threshold//./ })
    if [ "\''${versionParts[0]}" == "10" ]; then
      sdkMajor=\''${versionParts[1]}
      sdkMinor=\''${versionParts[2]:-0}
      for minor in \$(seq \$(("\$sdkMinor" + 1)) 9); do
        ${lib.getExe gnused} \\
          -E "/VERSION_10_\''${sdkMajor}_\$minor/,/#endif/c\\ */" \\
          -i "\$dest/include/AvailabilityMacros.h"
      done
      for major in \$(seq \$(("\$sdkMajor" + 1)) 15); do
        ${lib.getExe gnused} \\
          -E "/VERSION_10_\$major/,/#endif/c\\ */" \\
          -i "\$dest/include/AvailabilityMacros.h"
      done
    fi

    cp "$out/share/availability/templates/os_availability.modulemap" "\$dest/include/"
    SCRIPT
    chmod a+x "$out/bin/gen-headers"

    patchShebangs "$out/bin"

    runHook postInstall
  '';

  meta.mainProgram = "gen-headers";
}
