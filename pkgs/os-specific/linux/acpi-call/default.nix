{ lib, stdenv, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  pname = "acpi-call";
  version = "2020-04-07-${kernel.version}";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "acpi_call";
    rev = "fe4cd0124099b88b61f83006023bc0d95e742e75";
    sha256 = "1rksbg78i7y2wzam9p6kbhx8rmkaiq0kqg8nj7k0j6d25m79289s";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    install -D acpi_call.ko $out/lib/modules/${kernel.modDirVersion}/misc/acpi_call.ko
    install -D -m755 examples/turn_off_gpu.sh $out/bin/test_discrete_video_off.sh
  '';

  meta = with lib; {
    maintainers = with maintainers; [ raskin mic92 ];
    inherit (src.meta) homepage;
    platforms = platforms.linux;
    description = "A module allowing arbitrary ACPI calls; use case: hybrid video";
  };
}
