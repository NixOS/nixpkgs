{ lib, stdenv, fetchFromGitHub, kernel, bc }:

stdenv.mkDerivation rec {
  pname = "rtl8821cu";
  version = "${kernel.version}-unstable-2023-09-10";

  src = fetchFromGitHub {
    owner = "morrownr";
    repo = "8821cu-20210916";
    rev = "f6d4598290c5e9c8e545130e8a31d130f6d135f4";
    hash = "sha256-jpMf8K9diJ3mbEkP9Cp+VwairK+pwiEGU/AtUIouCqM=";
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
