{ lib
, stdenv
, llvmPackages_10
, fetchFromGitHub
, cmake
, llvm_12
, ncurses
, readline
, zlib
, libxml2
, python3
}:
llvmPackages_10.stdenv.mkDerivation {
  pname = "hobbes";
  version = "unstable-2023-06-03";

  src = fetchFromGitHub {
    owner = "morganstanley";
    repo = "hobbes";
    rev = "88a712b85bc896a4c87e60c12321445f1cdcfd00";
    hash = "sha256-2v0yk35/cLKTjX0Qbc8cjc7Y6bamRSa9GpPvGoxL2Cw=";
  };

  # TODO: re-enable Python tests once they work on Python 3
  # currently failing with "I don't know how to decode the primitive type: b'bool'"
  postPatch = ''
    rm test/Python.C
  '';

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    llvm_12
    ncurses
    readline
    zlib
    libxml2
    python3
  ];

  doCheck = true;
  checkTarget = "test";

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A language and an embedded JIT compiler";
    longDescription = ''
      Hobbes is a a language, embedded compiler, and runtime for efficient
      dynamic expression evaluation, data storage and analysis.
    '';
    homepage = "https://github.com/morganstanley/hobbes";
    license = licenses.asl20;
    maintainers = with maintainers; [ kthielen thmzlt ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
