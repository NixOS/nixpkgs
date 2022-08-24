{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, kernel
, bc
}:

stdenv.mkDerivation rec {
  pname = "rtl8821ce";
  version = "${kernel.version}-unstable-2022-06-01";

  src = fetchFromGitHub {
    owner = "tomaspinho";
    repo = "rtl8821ce";
    rev = "be733dc86781c68571650b395dd0fa6b53c0a039";
    sha256 = "sha256-4PgISOjCSSGymz96VwE4jzcUiOEO+Ocuk2kJVIA+TQM=";
  };

  patches = fetchpatch {
    url = "https://github.com/tomaspinho/rtl8821ce/pull/291.patch";
    sha256 = "sha256-GCZ/iPtzF7PP0ZgagBev6r7IVQ2VenPoLKL9GnPSt+U=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = [ bc ] ++ kernel.moduleBuildDependencies;
  makeFlags = kernel.makeFlags;

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

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Realtek rtl8821ce driver";
    homepage = "https://github.com/tomaspinho/rtl8821ce";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ hhm ivar ];
    broken = stdenv.isAarch64;
  };
}
