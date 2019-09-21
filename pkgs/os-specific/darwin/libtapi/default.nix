{ lib, stdenv, fetchFromGitHub, cmake, python }:

stdenv.mkDerivation {
  name = "libtapi";
  src = fetchFromGitHub {
    owner = "tpoechtrager";
    repo = "apple-libtapi";
    rev = "3efb201881e7a76a21e0554906cf306432539cef";
    sha256 = "1vzm2sbszmxssbsik6363gs8r0il2kvp6faw97r52w4gyrlw14zf";
  };

  nativeBuildInputs = [ cmake python ];

  preConfigure = ''
    cd src/llvm
  '';

  cmakeFlags = [ "-DLLVM_INCLUDE_TESTS=OFF" ];

  buildFlags = "libtapi";

  installTarget = "install-libtapi";

  meta = with lib; {
    license = licenses.apsl20;
    maintainers = with maintainers; [ matthewbauer ];
  };

}
