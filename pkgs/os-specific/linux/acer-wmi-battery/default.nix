{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:

let
  release = "0.1.0-unstable-2025-04-24";

in
stdenv.mkDerivation {
  pname = "acer-wmi-battery";
  version = "${kernel.version}-${release}";

  src = fetchFromGitHub {
    owner = "frederik-h";
    repo = "acer-wmi-battery";
    rev = "0889d3ea54655eaa88de552b334911ce7375952f";
    hash = "sha256-mI6Ob9BmNfwqT3nndWf3jkz8f7tV10odkTnfApsNo+A=";
  };

  makeFlags = kernelModuleMakeFlags;

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail '/lib/modules/$(shell uname -r)/build' ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build
  '';

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    find . -name '*.ko' -exec xz -f {} \;
    install -Dm444 -t $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/platform/x86 *.ko.xz

    runHook postInstall
  '';

  meta = {
    description = "Driver for the Acer WMI battery health control interface";
    homepage = "https://github.com/frederik-h/acer-wmi-battery";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
}
