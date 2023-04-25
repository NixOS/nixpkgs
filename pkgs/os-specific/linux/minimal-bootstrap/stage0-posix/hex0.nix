{ runBareCommand
, system
, bootstrap-seeds-src
}:
let
  throwSystem = throw "Unsupported system: ${system}";
  arch = {
    i686-linux = "x86";
  }.${system} or throwSystem;

  seed = "${bootstrap-seeds-src}/POSIX/${arch}/hex0-seed";
  src = "${bootstrap-seeds-src}/POSIX/${arch}/hex0_${arch}.hex0";
in
runBareCommand "hex0" seed [ src (placeholder "out") ]
