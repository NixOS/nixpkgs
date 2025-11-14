{
  lib,
  apple-sdk,
  bison,
  buildPackages,
  flex,
  meson,
  mkAppleDerivation,
  replaceVars,
  stdenv,
  stdenvNoCC,
}:

let
  Libc = apple-sdk.sourceRelease "Libc";
  xnu = apple-sdk.sourceRelease "xnu";

  privateHeaders = stdenvNoCC.mkDerivation {
    name = "adv_cmds-deps-private-headers";

    buildCommand = ''
      install -D -t "$out/include/os" \
        '${Libc}/os/assumes.h' \
        '${xnu}/libkern/os/base_private.h'
    '';
  };

  # bootstrap_cmds is used to build libkrb5, which is a transitive dependency of Meson due to OpenLDAP.
  # This causes an infinite recursion unless Meson’s tests are disabled.
  mkAppleDerivation' = mkAppleDerivation.override {
    meson = meson.overrideAttrs { doInstallCheck = false; };
  };
in
mkAppleDerivation' {
  releaseName = "bootstrap_cmds";

  outputs = [
    "out"
    "man"
  ];

  xcodeHash = "sha256-N28WLkFo8fXiQqqpmRmOBE3BzqXHIy94fhZIxEkmOw4=";
  xcodeProject = "mig.xcodeproj";

  patches = [
    # Make sure that `mig` in nixpkgs uses the correct clang
    (replaceVars ./patches/0001-Specify-MIGCC-for-use-with-substitute.patch {
      clang = "${lib.getBin buildPackages.targetPackages.clang}/bin/${buildPackages.targetPackages.clang.targetPrefix}clang";
    })
    # `mig` by default only removes the working directory at the end of the script.
    # If an error happens, it is left behind. Always clean it up.
    ./patches/0002-Always-remove-working-directory.patch
  ];

  postPatch = ''
    # Fix the name to something Meson will like.
    substituteInPlace migcom.tproj/lexxer.l \
      --replace-fail 'y.tab.h' 'parser.tab.h'
  '';

  env.NIX_CFLAGS_COMPILE = "-I${privateHeaders}/include";

  nativeBuildInputs = [
    bison
    flex
  ];

  postInstall = ''
    mv "$out/bin/mig.sh" "$out/bin/mig"
    chmod a+x "$out/bin/mig"
    patchShebangs --build "$out/bin/mig"

    substituteInPlace "$out/bin/mig" \
      --replace-fail 'arch=`/usr/bin/arch`' 'arch=${stdenv.targetPlatform.darwinArch}' \
      --replace-fail '/usr/bin/mktemp' '${lib.getBin buildPackages.coreutils}/bin/mktemp' \
      --replace-fail '/usr/bin/xcrun' '${buildPackages.xcbuild.xcrun}/bin/xcrun'
  '';

  meta.description = "Contains mig command for generating headers from definitions";
}
