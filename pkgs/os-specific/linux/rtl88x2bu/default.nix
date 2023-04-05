{ lib, stdenv, fetchFromGitHub, kernel, bc }:

stdenv.mkDerivation rec {
  pname = "rtl88x2bu";
  version = "${kernel.version}-unstable-2023-02-24";

  src = fetchFromGitHub {
    owner = "morrownr";
    repo = "88x2bu-20210702";
    rev = "51a2fb94893c562ec5f2fabce0b80e4da4eda812";
    sha256 = "sha256-nTas2EkghZeQhc8bTtoQfHEl8QJtClXi9V1IxlIThbI=";
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
    description = "Realtek rtl88x2bu driver";
    homepage = "https://github.com/morrownr/88x2bu-20210702";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.ralith ];
  };
}
