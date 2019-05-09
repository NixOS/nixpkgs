{ lib, stdenv, fetchFromGitHub, cmake, python }:

stdenv.mkDerivation {
  name = "libtapi";
  src = fetchFromGitHub {
    owner = "tpoechtrager";
    repo = "apple-libtapi";
    rev = "cc6f49238569aa8991373195c889364f5dcd5617";
    sha256 = "00n9sr0khp2dsmsg7mfssq12b9cvdi03arzkpadvkaldy5vixb5s";
  };

  nativeBuildInputs = [ cmake python ];

  preConfigure = ''
    cd src/apple-llvm/src
  '';

  cmakeFlags = [ "-DLLVM_INCLUDE_TESTS=OFF" ];

  buildFlags = "libtapi";

  installTarget = "install-libtapi";

  meta = with lib; {
    license = licenses.apsl20;
    maintainers = with maintainers; [ matthewbauer ];
  };

}
