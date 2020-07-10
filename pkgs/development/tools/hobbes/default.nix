{ stdenv, fetchFromGitHub, cmake, llvm_6, ncurses, readline, zlib }:

stdenv.mkDerivation {
  name = "hobbes";
  version = "unstable-2020-05-19";

  src = fetchFromGitHub {
    owner = "morgan-stanley";
    repo = "hobbes";
    rev = "3d80a46b44a362a97a6b963a2bf788fd1f67ade1";
    sha256 = "03m915g3283z2nfdr03dj5k76wn917knfqxb0xj3qinbl4cka2p1";
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
    maintainers = with maintainers; [ kthielen thmzlt ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
