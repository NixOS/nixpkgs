{ lib, stdenv, fetchFromGitHub
, pythonPackages
, cmake
, llvmPackages
, libffi, libxml2, zlib
, withMan ? true
}:
stdenv.mkDerivation rec {

  pname   = "CastXML";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner  = pname;
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1qpgr5hyb692h7l5igmq53m6a6vi4d9qp8ks893cflfx9955h3ip";
  };

  nativeBuildInputs = [ cmake ] ++ stdenv.lib.optionals withMan [ pythonPackages.sphinx ];

  clangVersion = lib.getVersion llvmPackages.clang;

  cmakeFlags = [
    "-DCLANG_RESOURCE_DIR=${llvmPackages.clang-unwrapped}/lib/clang/${clangVersion}/"
    "-DSPHINX_MAN=${if withMan then "ON" else "OFF"}"
  ];

  buildInputs = [
    llvmPackages.clang-unwrapped
    llvmPackages.llvm
    libffi libxml2 zlib
  ];

  propagatedBuildInputs = [ llvmPackages.libclang ];

  # 97% tests passed, 97 tests failed out of 2881
  # mostly because it checks command line and nix append -isystem and all
  doCheck = false;
  checkPhase = ''
    # -E exclude 4 tests based on names
    # see https://github.com/CastXML/CastXML/issues/90
    ctest -E 'cmd.cc-(gnu|msvc)-((c-src-c)|(src-cxx))-cmd'
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/CastXML/CastXML";
    license = licenses.asl20;
    description = "Abstract syntax tree XML output tool";
    platforms = platforms.unix;
  };
}
