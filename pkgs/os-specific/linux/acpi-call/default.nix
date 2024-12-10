{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
}:

stdenv.mkDerivation rec {
  pname = "acpi-call";
  version = "1.2.2";
  name = "${pname}-${version}-${kernel.version}";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "acpi_call";
    rev = "v${version}";
    sha256 = "1s7h9y3adyfhw7cjldlfmid79lrwz3vqlvziw9nwd6x5qdj4w9vp";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    install -D acpi_call.ko $out/lib/modules/${kernel.modDirVersion}/misc/acpi_call.ko
    install -D -m755 examples/turn_off_gpu.sh $out/bin/test_discrete_video_off.sh
  '';

  meta = with lib; {
    maintainers = with maintainers; [
      raskin
      mic92
    ];
    homepage = "https://github.com/nix-community/acpi_call";
    platforms = platforms.linux;
    description = "A module allowing arbitrary ACPI calls; use case: hybrid video";
    mainProgram = "test_discrete_video_off.sh";
    license = licenses.gpl3Plus;
  };
}
