{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
}:
let
  version = "0.1.7-unstable-2025-10-22";

  ## Upstream has not been merging PRs.
  ## Nixpkgs maintainers are providing a
  ## repo with PRs merged until upstream is
  ## updated.
  src = fetchFromGitHub {
    owner = "amkillam";
    repo = "ryzen_smu";
    rev = "21c1e2c51832dccfac64981b345745ce0cccf524";
    hash = "sha256-JA7dH958IceuBvHTp4lPlHolzLN9bXDt9hmhxITvvJA=";
  };

  monitor-cpu = stdenv.mkDerivation {
    pname = "monitor-cpu";
    inherit version src;

    makeFlags = [
      "-C userspace"
    ];

    installPhase = ''
      runHook preInstall

      install userspace/monitor_cpu -Dm755 -t $out/bin

      runHook postInstall
    '';
  };
in
stdenv.mkDerivation {
  pname = "ryzen-smu-${kernel.version}";
  inherit version src;

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

  meta = {
    description = "Linux kernel driver that exposes access to the SMU (System Management Unit) for certain AMD Ryzen Processors";
    homepage = "https://github.com/amkillam/ryzen_smu";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      Cryolitia
      phdyellow
      aleksana
      bradleyjones
    ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "monitor_cpu";
  };
}
