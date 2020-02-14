{ fetchFromGitHub, makeWrapper
, cmake, llvmPackages, ncurses
, runtimeShell }:

let
  src = fetchFromGitHub {
    owner = "cquery-project";
    repo = "cquery";
    rev = "a95a6503d68a85baa25465ce147b7fc20f4a552e";
    sha256 = "0rxbdln7dqkdw4q8rhclssgwypq16g9flkwmaabsr8knckbszxrx";
    fetchSubmodules = true;
  };

  stdenv = llvmPackages.stdenv;

in
stdenv.mkDerivation {
  pname = "cquery";
  version = "2018-10-14";

  inherit src;

  nativeBuildInputs = [ cmake makeWrapper ];
  buildInputs = with llvmPackages; [ clang clang-unwrapped llvm ncurses ];

  cmakeFlags = [
    "-DSYSTEM_CLANG=ON"
    "-DCLANG_CXX=ON"
  ];

  shell = runtimeShell;
  postFixup = ''
    # We need to tell cquery where to find the standard library headers.

    standard_library_includes="\\\"-isystem\\\", \\\"${stdenv.lib.getDev stdenv.cc.libc}/include\\\""
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
