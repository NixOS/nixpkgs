{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:
let
  pname = "acpi-call";
  version = "1.2.2";
in
stdenv.mkDerivation {
  inherit pname;
  version = "${version}-${kernel.version}";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "acpi_call";
    rev = "v${version}";
    sha256 = "1s7h9y3adyfhw7cjldlfmid79lrwz3vqlvziw9nwd6x5qdj4w9vp";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    install -D acpi_call.ko $out/lib/modules/${kernel.modDirVersion}/misc/acpi_call.ko
    install -D -m755 examples/turn_off_gpu.sh $out/bin/test_discrete_video_off.sh
  '';

  meta = {
    maintainers = with lib.maintainers; [
      raskin
      mic92
    ];
    homepage = "https://github.com/nix-community/acpi_call";
    platforms = lib.platforms.linux;
    description = "Module allowing arbitrary ACPI calls; use case: hybrid video";
    mainProgram = "test_discrete_video_off.sh";
    license = lib.licenses.gpl3Plus;
  };
}
