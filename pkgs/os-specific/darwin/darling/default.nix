{stdenv, lib, fetchzip}:

stdenv.mkDerivation rec {
  pname = "darling";
  name = pname;

  src = fetchzip {
    url = "https://github.com/darlinghq/darling/archive/d2cc5fa748003aaa70ad4180fff0a9a85dc65e9b.tar.gz";
    sha256 = "11b51fw47nl505h63bgx5kqiyhf3glhp1q6jkpb6nqfislnzzkrf";
    postFetch = ''
      # Get rid of case conflict
      mkdir $out
      cd $out
      tar -xzf $downloadedFile --strip-components=1
      rm -r $out/src/libm
    '';
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
