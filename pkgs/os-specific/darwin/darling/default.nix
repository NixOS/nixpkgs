{stdenv, lib, fetchFromGitHub}:

stdenv.mkDerivation rec {
  pname = "darling";
  name = pname;
  version = "0.2019.8";

  src = fetchFromGitHub {
    owner = "darlinghq";
    repo = "darling";
    rev = "v${version}";
    sha256 = "1v3isad22fxn7vcs7yzy0j1wvsfgzk9mrszpigl17di4bgq2xri3";
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

  # buildInputs = [ cmake bison flex ];

  meta = with lib; {
    maintainers = with maintainers; [ matthewbauer ];
    license = licenses.gpl3;
    description = "Darwin/macOS emulation layer for Linux";
    platforms = platforms.darwin;
  };
}
