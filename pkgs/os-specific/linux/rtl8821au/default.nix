{ stdenv, fetchFromGitHub, kernel, bc }:

stdenv.mkDerivation rec {
  name = "rtl8821au-${kernel.version}-${version}";
  version = "5.1.5";

  src = fetchFromGitHub {
    owner = "zebulon2";
    repo = "rtl8812au";
    rev = "61d0cd95afc01eae64da0c446515803910de1a00";
    sha256 = "0dlzyiaa3hmb2qj3lik52px88n4mgrx7nblbm4s0hn36g19ylssw";
  };

  nativeBuildInputs = [ bc ];
  buildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" "format" ];

  NIX_CFLAGS_COMPILE="-Wno-error=incompatible-pointer-types";

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
    description = "rtl8821AU, rtl8812AU and rtl8811AU chipset driver with firmware";
    homepage = https://github.com/zebulon2/rtl8812au;
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ plchldr ];
  };
}
