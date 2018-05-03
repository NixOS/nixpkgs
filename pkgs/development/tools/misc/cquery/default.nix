{ stdenv, fetchFromGitHub, makeWrapper
, cmake, llvmPackages, ncurses }:

let
  src = fetchFromGitHub {
    owner = "cquery-project";
    repo = "cquery";
    rev = "34b357bc5e873d52d2aa41287c6e138244cea109";
    sha256 = "0i34v30cl73485bzpbis539x0iq9whpv0403ca5a9h6vqwnvdn7c";
    fetchSubmodules = true;
  };

  stdenv = llvmPackages.stdenv;

in
stdenv.mkDerivation rec {
  name    = "cquery-${version}";
  version = "2018-05-01";

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
    $out/bin/cquery --ci --test-unit
  '';

  meta = with stdenv.lib; {
    description = "A c/c++ language server powered by libclang";
    homepage    = https://github.com/cquery-project/cquery;
    license     = licenses.mit;
    platforms   = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.tobim ];
  };
}
