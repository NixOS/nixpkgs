{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
}:

stdenv.mkDerivation rec {
  name = "liquidtux-${version}-${kernel.version}";
  version = "unstable-2021-12-16";

  src = fetchFromGitHub {
    owner = "liquidctl";
    repo = "liquidtux";
    rev = "342defc0e22ea58f8ab2ab0f191ad3fd302c44cb";
    sha256 = "12rc3vzfq8vnq9x9ca6swk5ag0xkpgkzmga8ga7q80mah9kxbaax";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    install nzxt-grid3.ko nzxt-kraken2.ko nzxt-kraken3.ko nzxt-smart2.ko -Dm444 -t ${placeholder "out"}/lib/modules/${kernel.modDirVersion}/kernel/drivers/hwmon
  '';

  meta = with lib; {
    description = "Linux kernel hwmon drivers for AIO liquid coolers and other devices";
    homepage = "https://github.com/liquidctl/liquidtux";
    license = licenses.gpl2;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    maintainers = with maintainers; [ nickhu ];
    broken = lib.versionOlder kernel.version "5.10";
  };
}
