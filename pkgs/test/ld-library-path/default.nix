{ lib, stdenv }:

# This tests that libraries listed in LD_LIBRARY_PATH take precedence over those listed in RPATH.

let
  # A simple test library: libgreeting.so which exports a single function getGreeting() returning the good old hello greeting.
  libgreeting = stdenv.mkDerivation {
    name = "libgreeting";

    code = ''
      const char* getGreeting() { return "Hello, world!"; }
    '';

    unpackPhase = ''
      echo "$code" > libgreeting.c
    '';

    installPhase = ''
      mkdir -p $out/lib
      $CC -c -fpic libgreeting.c
      $CC -shared libgreeting.o -o $out/lib/libgreeting.so
    '';
  };

  # A variant of libgreeting.so that returns a different message.
  libgoodbye = libgreeting.overrideAttrs (_: {
    name = "libgoodbye";
    code = ''
      const char* getGreeting() { return "Goodbye, world!"; }
    '';
  });

  # A simple consumer of libgreeting.so that just prints the greeting to stdout.
  testProgram = stdenv.mkDerivation {
    name = "greeting-test";

    buildInputs = [ libgreeting ];

    code = ''
      #include <stdio.h>

      extern const char* getGreeting(void);

      int main() {
        puts(getGreeting());
      }
    '';

    unpackPhase = ''
      echo "$code" > greeting-test.c
    '';

    installPhase = ''
      mkdir -p $out/bin
      $CC -c greeting-test.c
      $CC greeting-test.o -lgreeting -o $out/bin/greeting-test

      # Now test the installed binaries right after compiling them. In particular,
      # don't do this in installCheckPhase because fixupPhase has been run by then!
      (
        export PATH=$out/bin
        set -x

        # Verify that our unmodified binary works as expected.
        [ "$(greeting-test)" = "Hello, world!" ]

        # And finally, test that a library in LD_LIBRARY_PATH takes precedence over the linked-in library.
        [ "$(LD_LIBRARY_PATH=${libgoodbye}/lib greeting-test)" = "Goodbye, world!" ]
      )
    '';

  };
in stdenv.mkDerivation {
  name = "test-LD_LIBRARY_PATH";
  nativeBuildInputs = [ testProgram ];

  buildCommand = ''
    # And for good measure, repeat the tests again from a separate derivation,
    # as fixupPhase done by the stdenv can (and has!) affect the result.

    [ "$(greeting-test)" = "Hello, world!" ]
    [ "$(LD_LIBRARY_PATH=${libgoodbye}/lib greeting-test)" = "Goodbye, world!" ]

    touch $out
  '';

  meta.platforms = lib.platforms.linux;
}
