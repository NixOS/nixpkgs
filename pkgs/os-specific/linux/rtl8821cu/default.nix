{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  bc,
}:

stdenv.mkDerivation {
  pname = "rtl8821cu";
  version = "${kernel.version}-unstable-2024-09-27";

  src = fetchFromGitHub {
    owner = "morrownr";
    repo = "8821cu-20210916";
    rev = "2dce552dc6aa0cdab427bfa810c3df002eab0078";
    hash = "sha256-8hGAfZyDCGl0RnPnYjc7iMEulZvoIGe2ghfIfoiz7ZI=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = [ bc ] ++ kernel.moduleBuildDependencies;
  makeFlags = kernel.makeFlags;

  prePatch = ''
    substituteInPlace ./Makefile \
      --replace-fail /lib/modules/ "${kernel.dev}/lib/modules/" \
      --replace-fail /sbin/depmod \# \
      --replace-fail '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
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
