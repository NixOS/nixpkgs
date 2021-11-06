{ lib, stdenv, fetchFromGitHub, kernel, bc }:

stdenv.mkDerivation rec {
  pname = "rtl88x2bu";
  version = "${kernel.version}-unstable-2021-11-04";

  src = fetchFromGitHub {
    owner = "morrownr";
    repo = "88x2bu";
    rev = "745d134080b74b92389ffe59c03dcfd6658f8655";
    sha256 = "0f1hsfdw3ar78kqzr4hi04kpp5wnx0hd29f9rm698k0drxaw1g44";
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
    homepage = "https://github.com/morrownr/88x2bu";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.ralith ];
  };
}
