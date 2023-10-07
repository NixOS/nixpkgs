{ lib
, stdenv
, fetchFromGitHub
, kernel
, bc
}:

stdenv.mkDerivation rec {
  pname = "rtl8821ce";
  version = "${kernel.version}-unstable-2023-05-04";

  src = fetchFromGitHub {
    owner = "tomaspinho";
    repo = "rtl8821ce";
    rev = "a478095a45d8aa957b45be4f9173c414efcacc6f";
    hash = "sha256-xqVxylKhL7vbC7m5Av6ven5i7OBkS2RHxrKzLOVBlgE=";
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
    description = "Realtek rtl8821ce driver";
    homepage = "https://github.com/tomaspinho/rtl8821ce";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ hhm ivar ];
    broken = stdenv.isAarch64 || ((lib.versions.majorMinor kernel.version) == "5.4" && kernel.isHardened);
  };
}
