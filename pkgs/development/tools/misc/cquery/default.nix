{ stdenv, fetchFromGitHub, makeWrapper
, cmake, llvmPackages, ncurses }:

let
  src = fetchFromGitHub {
    owner = "cquery-project";
    repo = "cquery";
    rev = "e45a9ebbb6d8bfaf8bf1a3135b6faa910afea37e";
    sha256 = "049gkqbamq4r2nz9yjcwq369zrmwrikzbhfza2x2vndqzaavq5yg";
    fetchSubmodules = true;
  };

  stdenv = llvmPackages.stdenv;

in
stdenv.mkDerivation rec {
  name    = "cquery-${version}";
  version = "2018-03-25";

  inherit src;

  nativeBuildInputs = [ cmake makeWrapper ];
  buildInputs = with llvmPackages; [ clang clang-unwrapped llvm ncurses ];

  cmakeFlags = [
    "-DSYSTEM_CLANG=ON"
    "-DCLANG_CXX=ON"
  ];

  shell = stdenv.shell;
  postFixup = ''
    # We need to tell cquery where to find the standard library headers.

    standard_library_includes="\\\"-isystem\\\", \\\"${if (stdenv.hostPlatform.libc == "glibc") then stdenv.cc.libc.dev else stdenv.cc.libc}/include\\\""
    standard_library_includes+=", \\\"-isystem\\\", \\\"${llvmPackages.libcxx}/include/c++/v1\\\""
    export standard_library_includes

    wrapped=".cquery-wrapped"
    export wrapped

    mv $out/bin/cquery $out/bin/$wrapped
    substituteAll ${./wrapper} $out/bin/cquery
    chmod --reference=$out/bin/$wrapped $out/bin/cquery
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    pushd ${src}
    $out/bin/cquery --ci --clang-sanity-check && \
    $out/bin/cquery --ci --test-unit
  '';

  meta = with stdenv.lib; {
    description = "A c/c++ language server powered by libclang";
    homepage    = https://github.com/cquery-project/cquery;
    license     = licenses.mit;
    platforms   = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.tobim ];
    priority    = 3;
  };
}
