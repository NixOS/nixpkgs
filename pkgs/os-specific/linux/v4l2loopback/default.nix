{ stdenv, fetchFromGitHub, kernel, kmod }:

stdenv.mkDerivation rec {
  name = "v4l2loopback-${version}-${kernel.version}";
  version = "0.12.3";

  src = fetchFromGitHub {
    owner = "umlaeute";
    repo = "v4l2loopback";
    rev = "v${version}";
    sha256 = "01wahmrh4iw27cfmypik6frapq14vn7m9shmj5g7cr1apz2523aq";
  };

  hardeningDisable = [ "format" "pic" ];

  preBuild = ''
    substituteInPlace Makefile --replace "modules_install" "INSTALL_MOD_PATH=$out modules_install"
    sed -i '/depmod/d' Makefile
    export PATH=${kmod}/sbin:$PATH
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;
  buildInputs = [ kmod ];

  makeFlags = [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  meta = with stdenv.lib; {
    description = "A kernel module to create V4L2 loopback devices";
    homepage = https://github.com/umlaeute/v4l2loopback;
    license = licenses.gpl2;
    maintainers = [ maintainers.domenkozar ];
    platforms = platforms.linux;
  };
}
