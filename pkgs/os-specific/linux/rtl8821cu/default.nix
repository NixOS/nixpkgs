{ lib, stdenv, fetchFromGitHub, kernel, bc }:
stdenv.mkDerivation rec {
  name = "rtl8821cu-${kernel.version}-${version}";
  version = "unstable-2020-12-21";

  src = fetchFromGitHub {
    owner = "brektrou";
    repo = "rtl8821cu";
    rev = "428a0820487418ec69c0edb91726d1cf19763b1e";
    sha256 = "1ccl94727yq7gzn37ky91k0736cambgnkaa37r2f2hinpl9qdd8q";
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

  meta = with lib; {
    description = "Realtek rtl8821cu driver";
    homepage = "https://github.com/brektrou/rtl8821CU";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.contrun ];
  };
}
