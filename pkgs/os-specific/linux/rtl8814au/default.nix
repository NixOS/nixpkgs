{ stdenv, fetchFromGitHub, fetchpatch, kernel }:

stdenv.mkDerivation rec {
  name = "rtl8814au-${kernel.version}-${version}";
  version = "4.3.21";

  src = fetchFromGitHub {
    owner = "zebulon2";
    repo = "rtl8814au";
    rev = "a58c56a5a6cb99ffb872f07cb67b68197911854f";
    sha256 = "1ffm67da183nz009gm5v9w1bab081hrm113kk8knl9s5qbqnn13q";
  };

  buildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

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
    description = "Realtek 8814AU USB WiFi driver";
    homepage = https://github.com/zebulon2/rtl8814au;
    license = licenses.gpl2;
    maintainers = [ maintainers.lassulus ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
