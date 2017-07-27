{ lib, clangStdenv, clang-sierraHack-stdenv }:

let
  makeBigExe = stdenv: prefix: rec {

    count = 500;

    sillyLibs = lib.genList (i: stdenv.mkDerivation rec {
      name = "${prefix}-fluff-${toString i}";
      unpackPhase = ''
        src=$PWD
        cat << 'EOF' > ${name}.c
        unsigned int asdf_${toString i}(void) {
          return ${toString i};
        }
        EOF
      '';
      buildPhase = ''
        $CC -std=c99 -shared ${name}.c -o lib${name}.dylib -Wl,-install_name,$out/lib/lib${name}.dylib
      '';
      installPhase = ''
        mkdir -p "$out/lib"
        mv lib${name}.dylib "$out/lib"
      '';
    }) count;

    finalExe = stdenv.mkDerivation rec {
      name = "${prefix}-final-asdf";
      unpackPhase = ''
        src=$PWD
        cat << 'EOF' > main.cxx

        #include <assert.h>

        ${toString (lib.genList (i: "extern unsigned int asdf_${toString i}(void); ") count)}

        unsigned int (*funs[])(void) = {
          ${toString (lib.genList (i: "asdf_${toString i},") count)}
        };

        int main(int argc, char **argv) {
          unsigned int i = 0;
          for (auto f : funs) {
            assert(f() == i++);
          }
          return 0;
        }
        EOF
      '';
      buildPhase = ''
        $CC -std=c++11 main.cxx ${toString (map (x: "-l${x.name}") sillyLibs)} -o asdf
      '';
      buildInputs = sillyLibs;
      installPhase = ''
        mkdir -p "$out/bin"
        mv asdf "$out/bin"
      '';
    };

  };

in {
  good = makeBigExe clang-sierraHack-stdenv "good";
  bad  = makeBigExe clangStdenv             "bad";
}
