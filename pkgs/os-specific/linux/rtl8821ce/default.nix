{ stdenv, fetchFromGitHub, kernel, bc }:
stdenv.mkDerivation rec {
  name = "rtl8821ce-${kernel.version}-${version}";
  version = "5.2.5_1.26055.20180108";

  src = fetchFromGitHub {
    owner = "tomaspinho";
    repo = "rtl8821ce";
    rev = "66097bb98c8eb9e009865b9b6a610d56d3fd6f05";
    sha256 = "10l6ja2s7p189ibhnyqlj41zv4323x21fa50k082ahg32fln92j9";
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
    description = "Realtek rtl8821ce driver";
    homepage = "https://github.com/tomaspinho/rtl8821ce";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.hhm ];
  };
}
