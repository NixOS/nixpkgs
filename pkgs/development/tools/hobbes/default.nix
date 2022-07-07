{ lib, stdenv, fetchFromGitHub, cmake, llvm_12, ncurses, readline, zlib, libxml2 }:

stdenv.mkDerivation {
  pname = "hobbes";
  version = "unstable-2021-04-28";

  src = fetchFromGitHub {
    owner = "morgan-stanley";
    repo = "hobbes";
    rev = "737c7ca63516f6b3dca0e659c3de75d4325472d6";
    sha256 = "0fjsmz1sbrp6464mrb9ha7p615w2l2pdldsc2ayvcrvxfyi1r4gj";
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
