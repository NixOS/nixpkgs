{
  dyld,
  fetchFromGitHub,
  lib,
  libobjc,
  libtapi,
  libunwind,
  llvm,
  memstreamHook,
  ncurses,
  stdenv,
  symlinkJoin,
  tcsh,
  xar,
  xcbuildHook,
}: let
  cctools = stdenv.mkDerivation (finalAttrs: {
    pname = "cctools";
    version = "986";

    src = fetchFromGitHub {
      owner = "apple-oss-distributions";
      repo = finalAttrs.pname;
      rev = "${finalAttrs.pname}-${finalAttrs.version}";
      hash = "sha256-Fc9Bmx6/ya8+jJuKKFcqB4gTmiV1P+SScKT6CyCXAbc=";
    };

    patches = [
      ./cctools-add-missing-vtool-libstuff-dep.patch
    ];

    postPatch = ''
      for file in libstuff/writeout.c misc/libtool.c misc/lipo.c; do
        substituteInPlace "$file" \
          --replace '__builtin_available(macOS 10.12, *)' '0'
      done
      substituteInPlace libmacho/swap.c \
        --replace '#ifndef RLD' '#if 1'
    '';

    nativeBuildInputs = [xcbuildHook memstreamHook];
    buildInputs = [libobjc llvm ncurses.dev];

    xcbuildFlags = [
      "MACOSX_DEPLOYMENT_TARGET=10.12"
    ];

    doCheck = true;
    checkPhase = ''
      runHook preCheck

      Products/Release/libstuff_test
      rm Products/Release/libstuff_test

      runHook postCheck
    '';

    installPhase = ''
      runHook preInstall

      rm -rf "$out/usr"
      mkdir -p "$out/bin"
      find Products/Release -maxdepth 1 -type f -perm 755 -exec cp {} "$out/bin/" \;
      cp -r include "$out/"

      ln -s ./nm-classic "$out"/bin/nm
      ln -s ./otool-classic "$out"/bin/otool

      runHook postInstall
    '';
  });

  ld64 = stdenv.mkDerivation (finalAttrs: {
    pname = "ld64";
    version = "711";

    src = fetchFromGitHub {
      owner = "apple-oss-distributions";
      repo = finalAttrs.pname;
      rev = "${finalAttrs.pname}-${finalAttrs.version}";
      hash = "sha256-hQ/YID9teDTt7M23CkxJWrHxSPJbO3XFnjPTr96jOrw=";
    };

    postPatch = ''
      substituteInPlace ld64.xcodeproj/project.pbxproj \
        --replace "/bin/csh" "${tcsh}/bin/tcsh" \
        --replace 'F9E8D4BE07FCAF2A00FD5801 /* PBXBuildRule */,' "" \
        --replace 'F9E8D4BD07FCAF2000FD5801 /* PBXBuildRule */,' ""

      sed -i src/ld/Options.cpp -e '1iconst char ldVersionString[] = "${finalAttrs.version}";'
    '';

    nativeBuildInputs = [xcbuildHook];
    # TODO(@connorbaker): https://github.com/NixOS/nixpkgs/issues/149692#issuecomment-1409604806
    buildInputs = [
      # TODO(@connorbaker): What provides <System/machine/cpu_capabilities.h>?
      #   The System framework doesn't.
      dyld # for <mach-o/dyld_priv.h>
      libtapi
      libunwind
      llvm
      xar
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/bin"
      find Products/Release-assert -maxdepth 1 -type f -perm 755 -exec cp {} "$out/bin/" \;

      runHook postInstall
    '';
  });
in
  symlinkJoin rec {
    name = "cctools-${version}";
    version = "${cctools.version}-${ld64.version}";

    paths = [
      cctools
      ld64
    ];

    # workaround for the fetch-tarballs script
    passthru = {
      inherit (cctools) src;
      ld64_src = ld64.src;
    };

    meta = with lib; {
      description = "MacOS Compiler Tools";
      homepage = "http://www.opensource.apple.com/source/cctools/";
      license = licenses.apsl20;
      platforms = platforms.darwin;
    };
  }
