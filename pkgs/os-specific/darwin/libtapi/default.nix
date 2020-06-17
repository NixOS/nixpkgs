{ lib, stdenv, fetchFromGitHub, cmake, python3, clang_6 }:

stdenv.mkDerivation {
  name = "libtapi-1000.10.8";
  src = fetchFromGitHub {
    owner = "tpoechtrager";
    repo = "apple-libtapi";
    rev = "cd9885b97fdff92cc41e886bba4a404c42fdf71b";
    sha256 = "1a19h39a48agvnmal99n9j1fjadiqwib7hfzmn342wmgh9z3vk0g";
  };

  nativeBuildInputs = [ cmake python3 ];
  buildInputs = [ clang_6.cc ];

  preConfigure = ''
    cd src/llvm
  '';

  cmakeFlags = [ "-DLLVM_INCLUDE_TESTS=OFF" ];

  buildFlags = [ "libtapi" ];

  installTarget = "install-libtapi";

  meta = with lib; {
    license = licenses.apsl20;
    maintainers = with maintainers; [ matthewbauer ];
  };

}
