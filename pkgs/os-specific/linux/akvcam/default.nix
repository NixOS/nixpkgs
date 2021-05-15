{ lib, stdenv, fetchFromGitHub, kernel, qmake }:

stdenv.mkDerivation rec {
  pname = "akvcam";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "webcamoid";
    repo = "akvcam";
    rev = version;
    sha256 = "0r5xg7pz0wl6pq5029rpzm9fn978vq0md31xjkp2amny7rrgxw72";
  };

  nativeBuildInputs = [ qmake ];
  dontWrapQtApps = true;

  qmakeFlags = [
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    install -m644 -b -D src/akvcam.ko $out/lib/modules/${kernel.modDirVersion}/akvcam.ko
  '';

  meta = with lib; {
    description = "Virtual camera driver for Linux";
    homepage = "https://github.com/webcamoid/akvcam";
    maintainers = with maintainers; [ freezeboy ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
