{ stdenv, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  pname = "acpi-call";
  version = "2020-04-07-${kernel.version}";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "acpi_call";
    rev = "3d7c9fe5ed3fc5ed5bafd39d54b1fdc7a09ce710";
    sha256 = "09kp8zl392h99wjwzqrdw2xcfnsc944hzmfwi8n1y7m2slpdybv3";
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

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ raskin mic92 ];
    inherit (src.meta) homepage;
    platforms = platforms.linux;
    description = "A module allowing arbitrary ACPI calls; use case: hybrid video";
  };
}
