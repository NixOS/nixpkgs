{stdenv, lib, fetchFromGitHub, cmake, bison, flex}:

stdenv.mkDerivation rec {
  pname = "darling";
  name = pname;

  src = fetchFromGitHub {
    repo = pname;
    owner = "darlinghq";
    rev = "d2cc5fa748003aaa70ad4180fff0a9a85dc65e9b";
    sha256 = "1mkcnzy1cfpwghgvb9pszhy9jy6534y8krw8inwl9fqfd0w019wz";
  };

  # only packaging sandbox for now
  buildPhase = ''
    cc -c src/sandbox/sandbox.c -o src/sandbox/sandbox.o
    cc -dynamiclib -flat_namespace src/sandbox/sandbox.o -o libsystem_sandbox.dylib
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp -rL src/sandbox/include/ $out/
    cp libsystem_sandbox.dylib $out/lib/
  '';

  # buildInputs = [ cmake bison flex ];

  meta = with lib; {
    maintainers = with maintainers; [ matthewbauer ];
    license = licenses.gpl3;
    description = "Darwin/macOS emulation layer for Linux";
    platforms = platforms.darwin;
  };
}
