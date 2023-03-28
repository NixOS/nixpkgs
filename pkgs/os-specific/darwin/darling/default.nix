{stdenv, lib, fetchzip}:

stdenv.mkDerivation rec {
  pname = "darling";
  name = pname;

  src = fetchzip {
    url = "https://github.com/darlinghq/darling/archive/d2cc5fa748003aaa70ad4180fff0a9a85dc65e9b.tar.gz";
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

    mkdir -p $out/include
    cp src/libaks/include/* $out/include
  '';

  meta = with lib; {
    maintainers = with maintainers; [ matthewbauer ];
    license = licenses.gpl3;
    description = "Darwin/macOS emulation layer for Linux";
    platforms = platforms.darwin;
  };
}
