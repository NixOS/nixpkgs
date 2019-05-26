{ lib, stdenv, fetchFromGitHub, cmake, python }:

stdenv.mkDerivation {
  name = "libtapi";
  src = fetchFromGitHub {
    owner = "tpoechtrager";
    repo = "apple-libtapi";
    rev = "e56673694db395e25b31808b4fbb9a7005e6875f";
    sha256 = "1lnl1af9sszp9wxfk0wljrpdmwcx83j0w5c0y4qw4pqrdkdgwks7";
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
