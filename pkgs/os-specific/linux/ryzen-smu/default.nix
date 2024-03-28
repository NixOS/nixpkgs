{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, kernel
}:

let
  smu_version = "0.1.5-unstable-2024-01-03";

  ## Upstream has not been merging PRs.
  ## Nixpkgs maintainers are providing a
  ## repo with PRs merged until upstream is
  ## updated.
  smu_src = fetchFromGitHub {
    owner = "Cryolitia";
    repo = "ryzen_smu";
    rev = "ce1aa918efa33ca79998f0f7d467c04d4b07016c";
    hash = "sha256-s9SSmbL6ixWqZUKEhrZdxN4xoWgk+8ClZPoKq2FDAAE=";
  };

  monitor-cpu = stdenv.mkDerivation (finalAttrs: {
    pname = "monitor_cpu";
    version = smu_version;

    src = smu_src;

    makeFlags = [
      "-C userspace"
    ];

    installPhase = ''
    runHook preInstall

    install userspace/monitor_cpu -Dm755 -t $out/bin

    runHook postInstall
  '';
  });

in
stdenv.mkDerivation (finalAttrs: {
  pname = "ryzen_smu-${kernel.version}";
  version = smu_version;

  src = smu_src;

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "TARGET=${kernel.modDirVersion}"
    "KERNEL_BUILD=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    runHook preInstall

    install ryzen_smu.ko -Dm444 -t $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/ryzen_smu
    install ${monitor-cpu}/bin/monitor_cpu -Dm755 -t $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "A Linux kernel driver that exposes access to the SMU (System Management Unit) for certain AMD Ryzen Processors";
    homepage = "https://gitlab.com/leogx9r/ryzen_smu";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ Cryolitia phdyellow ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "monitor_cpu";
  };
})
