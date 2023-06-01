{ runCommand, cosmopolitan }:

let
  inherit (cosmopolitan) version;

  cosmocc =
    runCommand "cosmocc-${version}"
      {
        pname = "cosmocc";
        inherit version;

        meta = cosmopolitan.meta // {
          description = "compilers for Cosmopolitan C/C++ programs";
        };
        passthru.tests = {
          cc = runCommand "c-test" { } ''
            cat > hello.c << END
            #include <stdio.h>
            int main() {
              printf("Hello world!\n");
              return 0;
            }
            END
            ${cosmocc}/bin/cosmocc hello.c
            ./a.out > $out
          '';
        };
      } ''
      mkdir -p $out/bin
      install ${cosmopolitan.dist}/tool/scripts/{cosmocc,cosmoc++} $out/bin
      sed 's|/opt/cosmo\([ /]\)|${cosmopolitan.dist}\1|g' -i $out/bin/*
    '';
in
cosmocc
