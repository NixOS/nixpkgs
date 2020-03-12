{ stdenv, fetchFromGitHub, cmake, llvm_6, ncurses, readline, zlib }:

stdenv.mkDerivation {
  name = "hobbes";
  version = "unstable-2020-03-10";

  src = fetchFromGitHub {
    owner = "morgan-stanley";
    repo = "hobbes";
    rev = "ae956df9da3f3b24630bc1757dfaa2a8952db07a";
    sha256 = "1a0lb87vb0qcp5wy6swk4jcc88l7vhy6iflsk7zplw547mbjhjsy";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    llvm_6 # LLVM 6 is latest currently supported. See https://git.io/JvK6w.
    ncurses
    readline
    zlib
  ];

  doCheck = false; # Running tests in NixOS hangs. See https://git.io/JvK7R.
  checkTarget = "test";

  meta = with stdenv.lib; {
    description = "A language and an embedded JIT compiler";
    longDescription = ''
      Hobbes is a a language, embedded compiler, and runtime for efficient
      dynamic expression evaluation, data storage and analysis.
    '';
    homepage = "https://github.com/Morgan-Stanley/hobbes";
    license = licenses.asl20;
    maintainers = [ maintainers.thmzlt ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    broken = stdenv.isDarwin;
  };
}
