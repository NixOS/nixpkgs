{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  kernel,
  kernelModuleMakeFlags,
  nixosTests,
}:

let
  sourceAttrs = (import ./source.nix) { inherit fetchFromGitHub; };
in

stdenv.mkDerivation (finalAttrs: {
  name = "${finalAttrs.pname}-${finalAttrs.version}-${kernel.version}";
  pname = "jool";
  inherit (sourceAttrs) version;

  src = sourceAttrs.src;

  patches = lib.optionals (lib.versionAtLeast kernel.version "7.2") [
    # https://github.com/NICMx/Jool/pull/456
    (fetchpatch {
      url = "https://github.com/NICMx/Jool/commit/47a8c7426f08e50505e69eef7ff607a04fbab52e.diff";
      hash = "sha256-EcfBwFKOSFQOBWl8s5Pa2/RJg9lH1ziGzvV4ap2505M=";
    })
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies;
  hardeningDisable = [ "pic" ];

  prePatch = ''
    sed -e 's@/lib/modules/\$(.*)@${kernel.dev}/lib/modules/${kernel.modDirVersion}@' -i src/mod/*/Makefile
  '';

  makeFlags = kernelModuleMakeFlags ++ [
    "-C src/mod"
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];

  installTargets = "modules_install";

  passthru.tests = {
    inherit (nixosTests) jool;
  };

  meta = {
    homepage = "https://www.jool.mx/";
    description = "Fairly compliant SIIT and Stateful NAT64 for Linux - kernel modules";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fpletz ];
  };
})
