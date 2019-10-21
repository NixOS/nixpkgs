{ stdenv, pkgs, udev, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  name = "intel-sgx";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner  = "intel";
    repo   = "linux-sgx-driver";
    rev    = "4f5bb63a99b785f03bb6a03dc5402e99691b849b";
    sha256 = "0fqa3zm00c331pnqh8850w9dnlspcv7gvbxdn4shg9wxhklbi7m3";
  };

  buildInputs = kernel.moduleBuildDependencies;
  nativeBuildInputs = [ pkgs.kmod ];

  makeFlags = [ "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build/" ];

  installPhase = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/intel/sgx"
    cp isgx.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/intel/sgx
    rm -rf $out/build
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/intel/linux-sgx-driver;
    description = "Intel SGX Driver";
    platforms = stdenv.lib.platforms.linux;
    maintainers = with maintainers; [ exfalso ];
    license = stdenv.lib.licenses.bsd3;
  };
}
