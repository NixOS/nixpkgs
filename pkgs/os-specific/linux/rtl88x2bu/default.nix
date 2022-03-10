{ lib, stdenv, fetchFromGitHub, kernel, bc }:

stdenv.mkDerivation rec {
  pname = "rtl88x2bu";
  version = "${kernel.version}-unstable-2022-02-22";

  src = fetchFromGitHub {
    owner = "morrownr";
    repo = "88x2bu-20210702";
    rev = "6a5b7f005c071ffa179b6183ee034c98ed30db80";
    sha256 = "sha256-BqTyJpICW3D4EfHHoN5svasteJnunu2Uz449u/CmNE0=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = [ bc ];
  buildInputs = kernel.moduleBuildDependencies;

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
    description = "Realtek rtl88x2bu driver";
    homepage = "https://github.com/morrownr/88x2bu-20210702";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.ralith ];
  };
}
