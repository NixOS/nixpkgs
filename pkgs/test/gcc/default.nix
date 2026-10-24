{
  gccrs,
  gcobol,
  ga68,
  runCommand,
  lib,
}:

let
  # Compile source file and check that output is "Hello World!"
  testHelloWorld =
    {
      compiler,
      ext,
      code,
    }:
    runCommand "test-hello-world-${compiler.name}"
      {
        nativeBuildInputs = [ compiler ];
        inherit code ext;
        passAsFile = [ "code" ];
      }
      ''
        mv $codePath "hello.$ext"
        ${lib.getExe compiler} -o hello "hello.$ext"

        [[ $(./hello | tee /dev/stderr) = $'Hello World!' ]]
        touch $out
      '';
in
{
  gcobol-hello-world = testHelloWorld {
    compiler = gcobol;
    ext = "cbl";
    code = ''
      *> A SIMPLE HELLO WORLD PROGRAM
       IDENTIFICATION DIVISION.
       PROGRAM-ID. hello.
       PROCEDURE DIVISION.
           DISPLAY "Hello World!".
           STOP RUN.
    '';
  };

  ga68-hello-world = testHelloWorld {
    compiler = ga68;
    ext = "a68";
    code = ''
      begin
        puts ("Hello World!'n")
      end
    '';
  };

  gccrs-exit-code =
    runCommand "test-${gccrs.name}"
      {
        env.GCCRS_INCOMPLETE_AND_EXPERIMENTAL_COMPILER_DO_NOT_USE = "1";
        nativeBuildInputs = [ gccrs ];
        code = ''
          fn main() -> isize {
              let v: isize = 1 + 1;
              return v;
          }
        '';
        passAsFile = [ "code" ];
      }
      ''
        mv $codePath exit2.rs
        ${lib.getExe gccrs} -o exit2 exit2.rs

        set +e
        ./exit2; status=$?
        set -e

        echo "expected 2, got $status"
        (( $status == 2 ))
        touch $out
      '';
}
