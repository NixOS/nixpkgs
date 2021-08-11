{ lib, stdenv, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  name = "rtl8814au-${kernel.version}-${version}";
  version = "5.8.51";

  src = fetchFromGitHub {
    owner = "aircrack-ng";
    repo = "rtl8814au";
    rev = "bdf80b5a932d5267cd1aff66fee8ac244cd38777";
    sha256 = "07m1wg2xbi60x1l1qcn7xbb7m2lfa9af61q2llqryx30m9rk2idk";
  };

  buildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  NIX_CFLAGS_COMPILE="-Wno-error=incompatible-pointer-types";

  prePatch = ''
    substituteInPlace ./Makefile \
      --replace /lib/modules/ "${kernel.dev}/lib/modules/" \
      --replace '$(shell uname -r)' "${kernel.modDirVersion}" \
      --replace /sbin/depmod \# \
      --replace '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  preInstall = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  meta = with lib; {
    description = "Realtek 8814AU USB WiFi driver";
    homepage = "https://github.com/aircrack-ng/rtl8814au";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.lassulus maintainers.chaduffy ];
    platforms = [ "x86_64-linux" ];
  };
}
