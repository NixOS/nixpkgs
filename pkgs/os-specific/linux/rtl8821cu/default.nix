{ lib, stdenv, fetchFromGitHub, kernel, bc }:

stdenv.mkDerivation {
  pname = "rtl8821cu";
  version = "${kernel.version}-unstable-2024-05-03";

  src = fetchFromGitHub {
    owner = "morrownr";
    repo = "8821cu-20210916";
    rev = "3eacc28b721950b51b0249508cc31e6e54988a0c";
    hash = "sha256-JP7mvwhnKqmkb/B0l4vhc11TBjjUA1Ubzbj/IVEXvBM=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = [ bc ] ++ kernel.moduleBuildDependencies;
  makeFlags = kernel.makeFlags;

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
    description = "Realtek rtl8821cu driver";
    homepage = "https://github.com/morrownr/8821cu";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.contrun ];
  };
}
