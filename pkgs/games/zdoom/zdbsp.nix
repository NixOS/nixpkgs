{ lib, stdenv, fetchzip, cmake, zlib }:

stdenv.mkDerivation rec {
  pname = "zdbsp";
  version = "1.19";

  src = fetchzip {
    url = "https://zdoom.org/files/utils/zdbsp/zdbsp-${version}-src.zip";
    sha256 = "1j6k0appgjjj3ffbll9hy9nnbqr17szd1s66q08zrbkfqf6g8f0d";
    stripRoot = false;
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    zlib
  ];

  installPhase = ''
    install -Dm755 zdbsp $out/bin/zdbsp
  '';

  meta = with lib; {
    description = "ZDoom's internal node builder for DOOM maps";
    homepage = "https://zdoom.org/wiki/ZDBSP";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ lassulus siraben ];
    platforms = platforms.unix;
  };
}
