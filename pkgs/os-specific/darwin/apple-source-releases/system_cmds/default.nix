{
  lib,
  stdenv,
  stdenvNoCC,
  appleDerivation,
  fetchFromGitHub,
  runCommand,
  gawk,
  meson,
  ninja,
  pkg-config,
  libdispatch,
  libmalloc,
  libplatform,
  Librpcsvc,
  libutil,
  ncurses,
  openbsm,
  pam,
  xnu,
  CoreFoundation,
  CoreSymbolication,
  DirectoryService,
  IOKit,
  Kernel,
  Libc,
  OpenDirectory,
  WebKit,
}:

let
  OpenDirectoryPrivate = stdenvNoCC.mkDerivation (finalAttrs: {
    name = "apple-private-framework-OpenDirectory";
    version = "146";

    src = fetchFromGitHub {
      owner = "apple-oss-distributions";
      repo = "OpenDirectory";
      rev = "OpenDirectory-${finalAttrs.version}";
      hash = "sha256-6fSl8PasCZSBfe0ftaePcBuSEO3syb6kK+mfDI6iR7A=";
    };

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/include/CFOpenDirectory" "$out/include/OpenDirectory"
      install -t "$out/include/CFOpenDirectory" \
        Core/CFOpenDirectoryPriv.h \
        Core/CFODTrigger.h
      touch "$out/include/CFOpenDirectory/CFOpenDirectoryConstantsPriv.h"
      install -t "$out/include/OpenDirectory" \
        Framework/OpenDirectoryPriv.h \
        Framework/NSOpenDirectoryPriv.h

      runHook postInstall
    '';
  });

  libmallocPrivate = stdenvNoCC.mkDerivation {
    pname = "libmalloc-private";
    version = lib.getVersion libmalloc;

    inherit (libmalloc) src;

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/include"
      cp -r private/*.h "$out/include"

      runHook postInstall
    '';
  };

  # Private xnu headers that are part of the source tree but not in the xnu derivation.
  xnuPrivate = stdenvNoCC.mkDerivation {
    pname = "xnu-private";
    version = lib.getVersion xnu;

    inherit (xnu) src;

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/include"
      cp libsyscall/wrappers/spawn/spawn_private.h "$out/include"

      runHook postInstall
    '';
  };
in
appleDerivation (finalAttrs: {
  nativeBuildInputs = [
    gawk
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libdispatch
    libplatform
    Librpcsvc
    libutil
    ncurses
    openbsm
    pam
    xnu
    CoreFoundation
    CoreSymbolication
    DirectoryService
    IOKit
    Kernel
    OpenDirectory
  ];

  postPatch = ''
    # Replace hard-coded, impure system paths with the output path in the store.
    sed -e "s|PATH=[^;]*|PATH='$out/bin'|" -i "pagesize/pagesize.sh"
  '';

  # A vendored meson.build is used instead of the upstream Xcode project.
  # This is done for a few reasons:
  # - The upstream project causes `xcbuild` to crash.
  #   See: https://github.com/facebookarchive/xcbuild/issues/188;
  # - Achieving the same flexibility regarding SDK version would require modifying the
  #   Xcode project, but modifying Xcode projects without using Xcode is painful; and
  # - Using Meson allows the derivation to leverage the robust Meson support in nixpkgs,
  #   and it allows it to use Meson features to simplify the build (e.g., generators).
  preConfigure = ''
    substitute '${./meson.build}' meson.build \
      --subst-var-by kernel '${Kernel}' \
      --subst-var-by libc_private '${Libc}' \
      --subst-var-by libmalloc_private '${libmallocPrivate}' \
      --subst-var-by opendirectory '${OpenDirectory}' \
      --subst-var-by opendirectory_private '${OpenDirectoryPrivate}' \
      --subst-var-by xnu '${xnu}' \
      --subst-var-by xnu_private '${xnuPrivate}' \
      --subst-var-by version '${finalAttrs.version}'
    cp '${./meson.options}' meson.options
  '';

  mesonFlags = [ (lib.mesonOption "sdk_version" stdenv.hostPlatform.darwinSdkVersion) ];

  meta = {
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      shlevy
      matthewbauer
    ];
  };
})
