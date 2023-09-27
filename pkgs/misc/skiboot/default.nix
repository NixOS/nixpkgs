{ stdenv
, lib
, pkgsCross
, openssl
, nixosTests
, hardware
, fetchFromGitHub
, fetchgit
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "skiboot-${hardware}";

  strictDeps = true;
  enableParallelBuilding = true;

  # openssl is used for signing during build time and also linked against
  nativeBuildInputs = [ pkgsCross.ppc64.buildPackages.gcc openssl ];
  buildInputs = [ openssl ];
  hardeningDisable = [ "format" ];

  prePatch = ''
    patchShebangs --build make_version.sh libstb/sign-with-local-keys.sh
  '';
  buildPhase = ''
    runHook preBuild

    export NIX_CFLAGS_COMPILE=$NIX_CFLAGS_COMPILE" -Wno-error"
    export CROSS=powerpc64-unknown-linux-gnuabielfv2-
    export SKIBOOT_VERSION=v${finalAttrs.version}
    make

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp skiboot.lid* $out

    runHook postInstall
  '';

  meta = {
    description = "OPAL boot and runtime firmware for POWER";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ moody ];
    platforms = lib.platforms.all;
  };

} // ((import ./targets.nix) {
  inherit fetchFromGitHub fetchgit nixosTests;
})."${hardware}")

