{ lib
, stdenv
, fetchFromGitHub
, boost
, cmake
, nasm
, libpng
}:

stdenv.mkDerivation rec {
  pname = "efficient-compression-tool";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "fhanau";
    repo = "Efficient-Compression-Tool";
    rev = "v${version}";
    sha256 = "sha256-ArjgEmA6vmJWgVmLvZ7wPdA0tdVrS9g8hz8hlNWsujU=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake nasm ];

  patches = [ ./use-nixpkgs-libpng.patch ];

  buildInputs = [ boost libpng ];

  cmakeDir = "../src";

  cmakeFlags = [ "-DECT_FOLDER_SUPPORT=ON" ];

  meta = with lib; {
    description = "Fast and effective C++ file optimizer";
    homepage = "https://github.com/fhanau/Efficient-Compression-Tool";
    license = licenses.asl20;
    maintainers = [ maintainers.lunik1 ];
    platforms = platforms.linux;
  };
}
