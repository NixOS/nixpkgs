{ stdenv, fetchFromGitHub, kernel, bc }:
stdenv.mkDerivation rec {
  name = "rtl8821cu-${kernel.version}-${version}";
  version = "unstable-2020-05-16";

  src = fetchFromGitHub {
    owner = "brektrou";
    repo = "rtl8821cu";
    rev = "5c510c9f14352fed4906a10921040b9e46b58346";
    sha256 = "1n74h1m3l2dj35caswaghzcjwcv5qlv3gj6j1rqdddbyg5khl4ag";
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

  meta = with stdenv.lib; {
    description = "Realtek rtl8821cu driver";
    homepage = "https://github.com/brektrou/rtl8821CU";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.contrun ];
  };
}
