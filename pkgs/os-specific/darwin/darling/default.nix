{stdenv, lib, fetchzip}:

stdenv.mkDerivation rec {
  pname = "darling";
  name = pname;

  src = fetchzip {
    url = "https://github.com/darlinghq/darling/archive/d2cc5fa748003aaa70ad4180fff0a9a85dc65e9b.tar.gz";
    sha256 = "11b51fw47nl505h63bgx5kqiyhf3glhp1q6jkpb6nqfislnzzkrf";
    postFetch = ''
      # The archive contains both `src/opendirectory` and `src/OpenDirectory`,
      # pre-create the directory to choose the canonical case on
      # case-insensitive filesystems.
      mkdir -p $out/src/OpenDirectory

      cd $out
      tar -xzf $downloadedFile --strip-components=1
      rm -r $out/src/libm

      # If `src/opendirectory` and `src/OpenDirectory` refer to different
      # things, then combine them into `src/OpenDirectory` to match the result
      # on case-insensitive filesystems.
      if [ "$(stat -c %i src/opendirectory)" != "$(stat -c %i src/OpenDirectory)" ]; then
        mv src/opendirectory/* src/OpenDirectory/
        rmdir src/opendirectory
      fi
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

  meta = with lib; {
    maintainers = with maintainers; [ matthewbauer ];
    license = licenses.gpl3;
    description = "Darwin/macOS emulation layer for Linux";
    platforms = platforms.darwin;
  };
}
