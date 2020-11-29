{ stdenv, fetchFromGitHub, kernel }:

assert stdenv.lib.versionAtLeast kernel.version "5.0";

stdenv.mkDerivation rec {
  pname = "vendor-reset";
  version = "0.0.18";

  src = fetchFromGitHub {
    owner = "gnif";
    repo = pname;
    rev = "a6458b3dbf62b00844e52fb4f2e0b679eaf1e625";
    sha256 = "0lq8j2qpvym5jhkab78kyc7flg3wfzpwnjc7kjdsgbzg2g2nm8d2";
  };

  makeFlags = [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/gnif/vendor-reset";
    description = "Kernel module that is capable of resetting hardware devices";
    maintainers = with maintainers; [ chiiruno ];
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" ];
  };
}
