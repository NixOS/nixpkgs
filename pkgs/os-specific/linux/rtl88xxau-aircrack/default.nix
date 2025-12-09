{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
}:

stdenv.mkDerivation {
  pname = "rtl88xxau-aircrack";
  version = "${kernel.version}-unstable-2024-04-09";

  src = fetchFromGitHub {
    owner = "aircrack-ng";
    repo = "rtl8812au";
    rev = "63cf0b4584aa8878b0fe8ab38017f31c319bde3d";
    hash = "sha256-tDsI/ZzsQm9999EpCpDFArfEIg/ueUJEbSYESbGxd4A=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  prePatch = ''
    substituteInPlace ./Makefile \
      --replace /lib/modules/ "${kernel.dev}/lib/modules/" \
      --replace /sbin/depmod \# \
      --replace '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  preInstall = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = ''
      Aircrack-ng kernel module for Realtek 88XXau network cards
      (8811au, 8812au, 8814au and 8821au chipsets) with monitor mode and injection support.'';
    homepage = "https://github.com/aircrack-ng/rtl8812au";
    license = licenses.gpl2Only;
    maintainers = [
      maintainers.ja1den
      maintainers.jethro
    ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
      "aarch64-linux"
    ];
    broken = kernel.kernelAtLeast "6.17";
  };
}
