{ stdenv, fetchFromGitHub, fetchpatch, cmake, pkgconfig }:

stdenv.mkDerivation {
  pname = "raspberrypi-tools";
  version = "2020-05-28";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "userland";
    rev = "f97b1af1b3e653f9da2c1a3643479bfd469e3b74";
    sha256 = "1r7n05rv96hqjq0rn0qzchmfqs0j7vh3p8jalgh66s6l0vms5mwy";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  patches = [
    (fetchpatch {
      # https://github.com/raspberrypi/userland/pull/670
      url = "https://github.com/raspberrypi/userland/pull/670/commits/37cb44f314ab1209fe2a0a2449ef78893b1e5f62.patch";
      sha256 = "1fbrbkpc4cc010ji8z4ll63g17n6jl67kdy62m74bhlxn72gg9rw";
    })
  ];

  preConfigure = ''
    cmakeFlagsArray+=("-DVMCS_INSTALL_PREFIX=$out")
  '' + stdenv.lib.optionalString stdenv.isAarch64 ''
    cmakeFlagsArray+=("-DARM64=1")
  '';

  meta = with stdenv.lib; {
    description = "Userland tools for the Raspberry Pi board";
    homepage = "https://github.com/raspberrypi/userland";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" "armv6l-linux" "armv7l-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ dezgeg tavyc ];
  };
}
