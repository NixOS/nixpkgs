{ lib, stdenv, fetchurl, kernel, kmod, mstflint }:

stdenv.mkDerivation rec {
  pname = "mstflint_access";
  inherit (mstflint) version;

  src = fetchurl {
    url = "https://github.com/Mellanox/mstflint/releases/download/v${version}/kernel-mstflint-${version}.tar.gz";
    hash = "sha256-bWYglHJUNCPT13N7aBdjbLPMZIk7vjvF+o9W3abDNr0=";
  };

  nativeBuildInputs = [ kmod ] ++ kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
    "KVER=${kernel.modDirVersion}"
    "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    install -D ${pname}.ko $out/lib/modules/${kernel.modDirVersion}/extra/${pname}.ko

    runHook postInstall
  '';

  meta = with lib; {
    description = "A kernel module for Nvidia NIC firmware update";
    homepage = "https://github.com/Mellanox/mstflint";
    license = [ licenses.gpl2Only ];
    maintainers = with maintainers; [ thillux ];
    platforms = platforms.linux;
  };
}
