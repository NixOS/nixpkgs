{ lib, stdenv, fetchFromGitHub, kernel }:
stdenv.mkDerivation rec {
  name = "hp-vendor-${version}-${kernel.version}";
  version = "master_jammy";

  passthru.moduleName = "hp-vendor";

  src = (fetchFromGitHub {
    owner = "pop-os";
    repo = "hp-vendor";
    rev = "eeb8e7432224902587089593083ec018fb7edbd8";
    sha256 = "sha256-y+naNa4jURzdh8N2uqeIgs9MGEP3J/0MG+AcTD6k2KY=";
  }) + "/dkms";

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildFlags = [
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    install -D hp_vendor.ko $out/lib/modules/${kernel.modDirVersion}/misc/hp_vendor.ko
  '';

  meta = with lib; {
    maintainers = [ maintainers.cidkidnix ];
    license = [ licenses.gpl2Plus ];
    platforms = [ "i686-linux" "x86_64-linux" ];
    broken = versionOlder kernel.version "4.14";
    description = "System76 HP-Vendor DKMS driver";
    homepage = "https://github.com/pop-os/hp-vendor";
    longDescription = ''
      The System76 HP vendor DKMS driver
    '';
  };
}
