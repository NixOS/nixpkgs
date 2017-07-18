{ lib, clangStdenv, clang-sierraHack-stdenv }:

let
  makeBigExe = stdenv: prefix: rec {

    sillyLibs = lib.genList (i: stdenv.mkDerivation rec {
      name = "${prefix}-fluff-${toString i}";
      unpackPhase = ''
        src=$PWD
        echo 'int asdf${toString i}(void) { return ${toString i}; }' > ${name}.c
      '';
      buildPhase = ''
        $CC -shared ${name}.c -o lib${name}.dylib -Wl,-install_name,$out/lib/lib${name}.dylib
      '';
      installPhase = ''
        mkdir -p "$out/lib"
        mv lib${name}.dylib "$out/lib"
      '';
    }) 500
    ;

    finalExe = stdenv.mkDerivation rec {
      name = "${prefix}-final-asdf";
      unpackPhase = ''
        src=$PWD
        echo 'int main(int argc, char **argv) { return argc; }' > main.c;
      '';
      buildPhase = ''
        $CC main.c ${toString (map (x: "-l${x.name}") sillyLibs)} -o asdf
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
