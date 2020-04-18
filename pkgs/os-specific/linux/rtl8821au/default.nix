{ stdenv, fetchFromGitHub, kernel, bc, nukeReferences }:

stdenv.mkDerivation rec {
  name = "rtl8821au-${kernel.version}-${version}";
  version = "5.1.5+41";

  src = fetchFromGitHub {
    owner = "zebulon2";
    repo = "rtl8812au";
    rev = "ecd3494c327c54110d21346ca335ef9e351cb0be";
    sha256 = "1kmdxgbh0s0v9809kdsi39p0jbm5cf10ivy40h8qj9hn70g1gw8q";
  };

  nativeBuildInputs = [ bc nukeReferences ];
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

  postInstall = ''
    nuke-refs $out/lib/modules/*/kernel/net/wireless/*.ko
  '';

  meta = with stdenv.lib; {
    description = "rtl8821AU, rtl8812AU and rtl8811AU chipset driver with firmware";
    homepage = "https://github.com/zebulon2/rtl8812au";
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ plchldr ];
  };
}
