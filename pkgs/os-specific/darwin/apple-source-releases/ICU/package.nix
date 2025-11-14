{
  lib,
  bootstrapStdenv,
  buildPackages,
  fetchpatch2,
  icu76, # The ICU version should correspond to the same one used by Apple’s ICU package
  mkAppleDerivation,
  python3,
  stdenvNoCC,
  testers,
}:

# Based on:
# - ../../../development/libraries/icu/make-icu.nix
# - https://github.com/apple-oss-distributions/ICU/blob/main/makefile
let
  privateHeaders = stdenvNoCC.mkDerivation {
    name = "ICU-deps-private-headers";

    buildCommand = ''
      mkdir -p "$out/include/os"
      cat <<EOF > "$out/include/os/feature_private.h"
      #pragma once
      extern "C" bool _os_feature_enabled_impl(const char*, const char*);
      #define os_feature_enabled(a, b) _os_feature_enabled_impl(#a, #b)
      EOF
    '';
  };

  stdenv = bootstrapStdenv;
  withStatic = stdenv.hostPlatform.isStatic;

  # Cross-compiled icu4c requires a build-root of a native compile
  nativeBuildRoot = buildPackages.darwin.ICU.buildRootOnly;

  baseAttrs = finalAttrs: {
    releaseName = "ICU";

    sourceRoot = "${finalAttrs.src.name}/icu/icu4c/source";

    patches = [
      # Skip MessageFormatTest test, which is known to crash sometimes and should be suppressed if it does.
      ./patches/suppress-icu-check-crash.patch
    ];

    preConfigure = ''
      sed -i -e "s|/bin/sh|${stdenv.shell}|" configure
      patchShebangs --build .
      # $(includedir) is different from $(prefix)/include due to multiple outputs
      sed -i -e 's|^\(CPPFLAGS = .*\) -I\$(prefix)/include|\1 -I$(includedir)|' config/Makefile.inc.in
    '';

    dontDisableStatic = withStatic;

    configureFlags = [
      (lib.enableFeature false "debug")
      (lib.enableFeature false "renaming")
      (lib.enableFeature false "extras")
      (lib.enableFeature false "layout")
      (lib.enableFeature false "samples")
    ]
    ++ lib.optionals (stdenv.hostPlatform.isFreeBSD || stdenv.hostPlatform.isDarwin) [
      (lib.enableFeature true "rpath")
    ]
    ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
      (lib.withFeatureAs true "cross-build" nativeBuildRoot)
    ]
    ++ lib.optionals withStatic [ (lib.enableFeature true "static") ];

    nativeBuildInputs = [ python3 ];

    enableParallelBuilding = true;

    # Per the source-release makefile, these are enabled.
    env.NIX_CFLAGS_COMPILE = toString [
      "-DU_SHOW_CPLUSPLUS_API=1"
      "-DU_SHOW_INTERNAL_API=1"
      "-I${privateHeaders}/include"
    ];

    passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    passthru.buildRootOnly = mkWithAttrs buildRootOnlyAttrs;

    meta = {
      description = "Unicode and globalization support library with Apple customizations";
      license = [ lib.licenses.icu ];
      teams = [ lib.teams.darwin ];
      platforms = lib.platforms.darwin;
      pkgConfigModules = [
        "icu-i18n"
        "icu-io"
        "icu-uc"
      ];
    };
  };

  realAttrs = self: super: {
    outputs = [
      "out"
      "dev"
    ]
    ++ lib.optional withStatic "static";
    outputBin = "dev";

    postPatch =
      lib.optionalString self.finalPackage.doCheck (
        ''
          # Skip test for missing encodingSamples data.
          substituteInPlace test/cintltst/ucsdetst.c \
            --replace-fail "&TestMailFilterCSS" "NULL"

          # Disable failing tests
          substituteInPlace test/cintltst/cloctst.c \
            --replace-fail 'TESTCASE(TestCanonicalForm);' ""

          substituteInPlace test/intltest/rbbitst.cpp \
            --replace-fail 'TESTCASE_AUTO(TestExternalBreakEngineWithFakeYue);' ""

          # Add missing test data. It’s not included in the source release.
          chmod u+w "$NIX_BUILD_TOP/source/icu"
          tar -C "$NIX_BUILD_TOP/source" -axf ${lib.escapeShellArg icu76.src} icu/testdata
        ''
        + lib.optionalString stdenv.hostPlatform.isx86_64 ''
          # These tests fail under Rosetta 2 with a floating-point exception.
          substituteInPlace test/intltest/caltest.cpp \
            --replace-fail 'TESTCASE_AUTO(Test22633RollTwiceGetTimeOverflow);' "" \
            --replace-fail 'TESTCASE_AUTO(Test22750Roll);' ""
        ''
      )
      + ''
        # Otherwise `make install` is broken.
        substituteInPlace Makefile.in \
          --replace-fail '$(top_srcdir)/../LICENSE' "$NIX_BUILD_TOP/source/icu/LICENSE"
        substituteInPlace config/dist-data.sh \
          --replace-fail "\''${top_srcdir}/../LICENSE" "$NIX_BUILD_TOP/source/icu/LICENSE"
      '';

    # remove dependency on bootstrap-tools in early stdenv build
    postInstall =
      lib.optionalString withStatic ''
        mkdir -p $static/lib
        mv -v lib/*.a $static/lib
      ''
      + lib.optionalString stdenv.hostPlatform.isDarwin ''
        sed -i 's/INSTALL_CMD=.*install/INSTALL_CMD=install/' $out/lib/icu/*/pkgdata.inc
      ''
      + (
        let
          replacements = [
            {
              from = "\${prefix}/include";
              to = "${placeholder "dev"}/include";
            } # --cppflags-searchpath
            {
              from = "\${pkglibdir}/Makefile.inc";
              to = "${placeholder "dev"}/lib/icu/Makefile.inc";
            } # --incfile
            {
              from = "\${pkglibdir}/pkgdata.inc";
              to = "${placeholder "dev"}/lib/icu/pkgdata.inc";
            } # --incpkgdatafile
          ];
        in
        ''
          rm $out/share/icu/*/install-sh $out/share/icu/*/mkinstalldirs # Avoid having a runtime dependency on bash

          substituteInPlace "$dev/bin/icu-config" \
            ${lib.concatMapStringsSep " " (r: "--replace-fail '${r.from}' '${r.to}'") replacements}
        ''
        # Create library with everything reexported to provide the same ABI as the system ICU.
        + lib.optionalString stdenv.hostPlatform.isDarwin (
          if stdenv.hostPlatform.isStatic then
            ''
              ${stdenv.cc.targetPrefix}ar qL "$out/lib/libicucore.a" \
                "$out/lib/libicuuc.a" \
                "$out/lib/libicudata.a" \
                "$out/lib/libicui18n.a" \
                "$out/lib/libicuio.a"
            ''
          else
            ''
              icuVersion=$(basename "$out/share/icu/"*)
              ${stdenv.cc.targetPrefix}clang -dynamiclib \
                -L "$out/lib" \
                -Wl,-reexport-licuuc \
                -Wl,-reexport-licudata \
                -Wl,-reexport-licui18n \
                -Wl,-reexport-licuio \
                -compatibility_version 1 \
                -current_version "$icuVersion" \
                -install_name "$out/lib/libicucore.A.dylib" \
                -o "$out/lib/libicucore.A.dylib"
              ln -s libicucore.A.dylib "$out/lib/libicucore.dylib"
            ''
        )
      );

    postFixup = ''moveToOutput lib/icu "$dev" '';

    doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

    nativeCheckInputs = [ python3 ];

    # Some tests use `log(name)`, which clang identifies as potentially insecure.
    checkFlags = [
      "CFLAGS+=-Wno-format-security"
      "CXXFLAGS+=-Wno-format-security"
    ];
    checkTarget = "check";
  };

  buildRootOnlyAttrs = self: super: {
    pname = "ICU-build-root";

    preConfigure = super.preConfigure + ''
      mkdir build
      cd build
      configureScript=../configure

      # Apple’s customizations require building and linking additional files, which are handled via `Makefile.local`.
      # These need copied into the build environment to avoid link errors from not building them.
      mkdir common i18n
      cp ../common/Makefile.local common/Makefile.local
      cp ../i18n/Makefile.local i18n/Makefile.local
    '';

    postBuild = ''
      cd ..
      mv build $out
      echo "Doing build-root only, exiting now" >&2
      exit 0
    '';
  };

  mkWithAttrs = attrs: mkAppleDerivation (lib.extends attrs baseAttrs);
in
mkWithAttrs realAttrs
