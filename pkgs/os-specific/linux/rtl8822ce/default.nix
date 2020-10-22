{ stdenv, fetchFromGitHub, kernel, bc }:

stdenv.mkDerivation rec {
  # this is already available on newer kernels such as zen
  name = "rtl8822ce";
  version = "v5.9.0.3b";

  src = fetchFromGitHub {
    owner = "rtlwifi-linux";
    repo = "rtk_wifi_driver_rtl8822ce";
    rev = version;
    sha256 = "0cplb37r9dzmzcs9h283478z4szqs7w9ypd8r8pdzhzaa5057fqx";
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
    description = "Realtek rtl8822ce driver";
    homepage = "https://github.com/rtlwifi-linux/rtk_wifi_driver_rtl8822ce";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pickfire ];
  };
}
