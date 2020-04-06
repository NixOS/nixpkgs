{ stdenv, fetchFromGitLab, kernel }:

stdenv.mkDerivation rec {
  pname = "ddcci-driver";
  version = "0.3.2";
  name = "${pname}-${kernel.version}-${version}";

  src = fetchFromGitLab {
    owner = "${pname}-linux";
    repo = "${pname}-linux";
    rev = "v${version}";
    sha256 = "0jl4l3vvxn85cbqr80p6bgyhf2vx9kbadrwx086wkj9ni8k6x5m6";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  NIX_CFLAGS_COMPILE = [ "-Wno-error=incompatible-pointer-types" ];

  prePatch = ''
    substituteInPlace ./ddcci/Makefile \
      --replace 'SUBDIRS="$(src)"' 'M=$(PWD)' \
      --replace depmod \#
    substituteInPlace ./ddcci-backlight/Makefile \
      --replace 'SUBDIRS="$(src)"' 'M=$(PWD)' \
      --replace depmod \#
  '';

  makeFlags = [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "KVER=${kernel.modDirVersion}"
    "KERNEL_MODLIB=$(out)/lib/modules/${kernel.modDirVersion}"
    "INCLUDEDIR=$(out)/include"
  ];

  meta = with stdenv.lib; {
    description = "Kernel module driver for DDC/CI monitors";
    homepage = "https://gitlab.com/ddcci-driver-linux/ddcci-driver-linux";
    license = licenses.gpl2;
    maintainers = with maintainers; [ bricewge ];
    platforms = platforms.linux;
  };
}
