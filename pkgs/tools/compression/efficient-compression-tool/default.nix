{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  cmake,
  nasm,
  libpng,
}:

stdenv.mkDerivation rec {
  pname = "efficient-compression-tool";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "fhanau";
    repo = "Efficient-Compression-Tool";
    rev = "v${version}";
    sha256 = "sha256-TSV5QXf6GuHAwQrde3Zo9MA1rtpAhtRg0UTzMkBnHB8=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    nasm
  ];

  patches = [ ./use-nixpkgs-libpng.patch ];

  buildInputs = [
    boost
    libpng
  ];

  cmakeDir = "../src";

  cmakeFlags = [ "-DECT_FOLDER_SUPPORT=ON" ];

  CXXFLAGS = [
    # GCC 13: error: 'uint32_t' does not name a type
    "-include cstdint"
  ];

  meta = with lib; {
    description = "Fast and effective C++ file optimizer";
    homepage = "https://github.com/fhanau/Efficient-Compression-Tool";
    license = licenses.asl20;
    maintainers = [ maintainers.lunik1 ];
    platforms = platforms.linux;
    mainProgram = "ect";
  };
}
