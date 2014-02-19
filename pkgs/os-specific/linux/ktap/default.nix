{ stdenv, fetchgit, kernel }:

stdenv.mkDerivation rec {
  name = "ktap-${version}";
  version = "0.5-7ee59b19";
  src = fetchgit {
    url    = "https://github.com/ktap/ktap.git";
    rev    = "7ee59b19d536fd3d3164ff0a0623faff827e5d97";
    sha256 = "0a46836469d0afb088e72fd6310406a86c487d17bac40e390cec8bc869e7379c";
  };

  buildPhase = ''
    make FFI=1 KERNEL_SRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build
  '';

  installPhase = ''
    mkdir -p $out/sbin
    cp ktap $out/sbin
    make modules_install KERNEL_SRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build INSTALL_MOD_PATH=$out
  '';

  meta = {
    description = "A lightweight script-based dynamic tracing tool for Linux.";
    homepage    = "http://www.ktap.org";
    platforms   = stdenv.lib.platforms.linux;
    license     = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
