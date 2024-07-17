{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  bc,
}:

stdenv.mkDerivation rec {
  pname = "rtl8821ce";
  version = "${kernel.version}-unstable-2024-01-20";

  src = fetchFromGitHub {
    owner = "tomaspinho";
    repo = "rtl8821ce";
    rev = "66983b69120a13699acf40a12979317f29012111";
    hash = "sha256-Zxb9cOgP67QdCeTNEme0tAsBqd9j/2k+gcE1QKkUQU4=";
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
    maintainers = with maintainers; [ hhm ];
    broken =
      stdenv.isAarch64 || ((lib.versions.majorMinor kernel.version) == "5.4" && kernel.isHardened);
  };
}
