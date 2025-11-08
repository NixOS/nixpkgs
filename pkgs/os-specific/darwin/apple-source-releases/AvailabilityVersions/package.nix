{
  lib,
  apple-sdk,
  buildPackages,
  mkAppleDerivation,
  unifdef,
}:

let
  inherit (buildPackages) gnused python3;
  xnu = apple-sdk.sourceRelease "xnu";
in
mkAppleDerivation (finalAttrs: {
  releaseName = "AvailabilityVersions";

  patches = [
    # Add support for setting an upper bound, which is needed by the `gen-headers` script.
    # It avoids having pre-process the DSL to remove unwanted versions.
    ./patches/0001-Support-setting-an-upper-bound-on-versions.patch
  ];

  nativeBuildInputs = [ unifdef ];

  buildPhase = ''
    runHook preBuild

    declare -a unifdef_sources=(
      os_availability.modulemap
      os_availability_private.modulemap
    )
    unifdef -x2 -UBUILD_FOR_DRIVERKIT -m $(for x in "''${unifdef_sources[@]}"; do echo templates/$x; done)

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/libexec" "$out/share/availability"

    cp -r availability.dsl templates "$out/share/availability/"

    substitute availability "$out/libexec/availability" \
      --replace-fail '/usr/bin/env python3' '${lib.getExe python3}' \
      --replace-fail 'f"{os.path.abspath(os.path.dirname(sys.argv[0]))}/' "\"$out/share/availability/"
    chmod a+x "$out/libexec/availability"

    substitute ${xnu}/bsd/sys/make_symbol_aliasing.sh "$out/libexec/make_symbol_aliasing.sh" \
    ${
      if lib.versionOlder (lib.getVersion xnu) "6153.11.26" then
        ''--replace-fail "\''${SDKROOT}/usr/local/libexec/availability.pl" "$out/libexec/availability" \''
      else
        ''--replace-fail "\''${SDKROOT}/\''${DRIVERKITROOT}/usr/local/libexec/availability.pl" "$out/libexec/availability" \''
    }
      --replace-fail '--macosx' '--macosx --threshold $SDKROOT'
    chmod a+x "$out/libexec/make_symbol_aliasing.sh"

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

    "$out/libexec/make_symbol_aliasing.sh" \$threshold "\$dest/include/sys/_symbol_aliasing.h"

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

  meta = {
    description = "Generates Darwin Availability headers";
    mainProgram = "gen-headers";
    platforms = lib.platforms.unix;
  };
})
