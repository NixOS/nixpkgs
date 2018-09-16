{ fetchFromGitHub, makeWrapper
, cmake, llvmPackages, ncurses }:

let
  src = fetchFromGitHub {
    owner = "cquery-project";
    repo = "cquery";
    rev = "e17df5b41e5a687559a0b75dba9c0f1f399c4aea";
    sha256 = "06z8bg73jppb4msiqvsjbpz6pawwny831k56w5kcxrjgp22v24s1";
    fetchSubmodules = true;
  };

  stdenv = llvmPackages.stdenv;

in
stdenv.mkDerivation rec {
  name    = "cquery-${version}";
  version = "2018-08-08";

  inherit src;

  nativeBuildInputs = [ cmake makeWrapper ];
  buildInputs = with llvmPackages; [ clang clang-unwrapped llvm ncurses ];

  cmakeFlags = [
    "-DSYSTEM_CLANG=ON"
    "-DCLANG_CXX=ON"
    "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.12"
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

    # The integration tests have to be disabled because cquery ignores `--init`
    # if they are invoked, which means it won't find the system includes.
    #$out/bin/cquery --ci --test-index
  '';

  meta = with stdenv.lib; {
    description = "A c/c++ language server powered by libclang";
    homepage    = https://github.com/cquery-project/cquery;
    license     = licenses.mit;
    platforms   = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.tobim ];
  };
}
