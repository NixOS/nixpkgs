{ stdenv, lib, meson, coreutils, writeTextDir, buildPackages }:

stdenv.mkDerivation rec {
  name = "meson-builder-${meson.version}";

  unpackPhase = "true";
  installPhase = "true";

  setupHook = ./setup-hook.sh;

  nativeBuildInputs = [ meson coreutils ];
  crossFile =
    writeTextDir "cross-file.conf" ''
    [binaries]
    c = '${stdenv.cc.targetPrefix}cc'
    cpp = '${stdenv.cc.targetPrefix}c++'
    ar = '${stdenv.cc.bintools.targetPrefix}ar'
    strip = '${stdenv.cc.bintools.targetPrefix}strip'
    pkgconfig = 'pkg-config'

    [properties]
    needs_exe_wrapper = true

    [host_machine]
    system = '${stdenv.targetPlatform.parsed.kernel.name}'
    cpu_family = '${stdenv.targetPlatform.parsed.cpu.family}'
    cpu = '${stdenv.targetPlatform.parsed.cpu.name}'
    endian = ${if stdenv.targetPlatform.isLittleEndian then "'little'" else "'big'"}
  '';

  isCross = stdenv.buildPlatform != stdenv.hostPlatform;

  inherit (buildPackages.stdenv) cc;
}
