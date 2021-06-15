{ lib, stdenv, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  pname = "acpi-call";
  version = "1.2.1";
  name = "${pname}-${version}-${kernel.version}";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "acpi_call";
    rev = "v${version}";
    sha256 = "0mr4rjbv6fj4phf038addrgv32940bphghw2v9n1z4awvw7wzkbg";
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
    homepage = "https://github.com/nix-community/acpi_call";
    platforms = platforms.linux;
    description = "A module allowing arbitrary ACPI calls; use case: hybrid video";
    license = licenses.gpl3Plus;
  };
}
