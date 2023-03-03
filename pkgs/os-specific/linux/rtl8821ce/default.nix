{ lib
, stdenv
, fetchFromGitHub
, kernel
, bc
}:

stdenv.mkDerivation rec {
  pname = "rtl8821ce";
  version = "${kernel.version}-unstable-2023-01-01";

  src = fetchFromGitHub {
    owner = "tomaspinho";
    repo = "rtl8821ce";
    rev = "a3e2f7c1f91e92f2dc788e8fcd7f2986af3d19b6";
    sha256 = "sha256-eR4iTkRMnhNEBrUEC+fKlwq3hezNC9mSAQ7D0Wwss/0=";
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
