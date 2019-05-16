{ stdenv, fetchFromGitHub
, pythonPackages
, cmake
, llvmPackages
, withMan ? true
}:
stdenv.mkDerivation rec {

  name    = "${pname}-${version}";
  pname   = "CastXML";
  version = "20180403";

  src = fetchFromGitHub {
    owner  = "CastXML";
    repo   = "CastXML";
    rev    = "c2a44d06d9379718292b696f4e13a2725ff9d95e";
    sha256 = "1hjh8ihjyp1m2jb5yypp5c45bpbz8k004f4p1cjw4gc7pxhjacdj";
  };

  cmakeFlags = [
    "-DCLANG_RESOURCE_DIR=${llvmPackages.clang-unwrapped}"
    "-DSPHINX_MAN=${if withMan then "ON" else "OFF"}"
  ];

  buildInputs = [
    cmake
    llvmPackages.clang-unwrapped
    llvmPackages.llvm
  ] ++ stdenv.lib.optionals withMan [ pythonPackages.sphinx ];

  propagatedbuildInputs = [ llvmPackages.libclang ];

  # 97% tests passed, 96 tests failed out of 2866
  # mostly because it checks command line and nix append -isystem and all
  doCheck=false;
  checkPhase = ''
    # -E exclude 4 tests based on names
    # see https://github.com/CastXML/CastXML/issues/90
    ctest -E 'cmd.cc-(gnu|msvc)-((c-src-c)|(src-cxx))-cmd'
  '';

  meta = with stdenv.lib; {
    homepage = https://www.kitware.com;
    license = licenses.asl20;
    description = "Abstract syntax tree XML output tool";
    platforms = platforms.unix;
  };
}
