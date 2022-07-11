{ lib
, stdenv
, fetchFromGitHub
, cmake
, llvm
, ncurses
, readline
, zlib
, libxml2
, python }:

stdenv.mkDerivation {
  pname = "hobbes";
  version = "unstable-2022-07-06";

  src = fetchFromGitHub {
    owner = "morgan-stanley";
    repo = "hobbes";
    rev = "02eae25c379d756d5a79aabd9bf203053976ebde";
    sha256 = "sha256-GjblBdXtQrDszX2KFHE5aseUk4g6Jk7zJCkiwhMijlo=";
  };

  # TODO: re-enable Python tests once they work on Python 3
  # currently failing with "I don't know how to decode the primitive type: b'bool'"
  postPatch = ''
    rm test/Python.C
  '';

  nativeBuildInputs = [
    cmake
    python
  ];

  buildInputs = [
    llvm_12
    ncurses
    readline
    zlib
    libxml2
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
