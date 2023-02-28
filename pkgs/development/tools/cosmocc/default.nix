{ runCommand, lib, cosmopolitan }:

let
  cosmocc =
    runCommand "cosmocc"
      {
        pname = "cosmocc";
        inherit (cosmopolitan) version;

        meta = with lib; {
          homepage = "https://justine.lol/cosmopolitan/";
          description = "compilers for Cosmopolitan C/C++ programs";
          license = licenses.mit;
          maintainers = teams.cosmopolitan.members;
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
