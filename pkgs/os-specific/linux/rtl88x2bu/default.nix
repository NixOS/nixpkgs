{ lib, stdenv, fetchFromGitHub, kernel, bc }:

stdenv.mkDerivation {
  pname = "rtl88x2bu";
  version = "${kernel.version}-unstable-2023-07-20";

  src = fetchFromGitHub {
    owner = "morrownr";
    repo = "88x2bu-20210702";
    rev = "28bcb8b3eb4a531727c7a48001fa91903492fd1a";
    sha256 = "sha256-LeCPu9ypJUdKV4lwJIy934g+VqD1S6P0fgnczTI3z7c=";
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
    maintainers = with maintainers; [ otavio ralith ];
  };
}
