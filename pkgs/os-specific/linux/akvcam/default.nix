{ lib, fetchFromGitHub, kernel, buildModule }:

buildModule rec {
  pname = "akvcam";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "webcamoid";
    repo = "akvcam";
    rev = version;
    sha256 = "1f0vjia2d7zj3y5c63lx1r537bdjx6821yxy29ilbrvsbjq2szj8";
  };
  sourceRoot = "source/src";

  installPhase = ''
    install -m644 -b -D akvcam.ko $out/lib/modules/${kernel.modDirVersion}/akvcam.ko
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Virtual camera driver for Linux";
    homepage = "https://github.com/webcamoid/akvcam";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Only;
  };
}
