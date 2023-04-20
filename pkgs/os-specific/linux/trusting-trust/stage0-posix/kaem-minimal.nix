{ runBareCommand
, system
, bootstrap-seeds-src
, hex0
}:
let
  throwSystem = throw "Unsupported system: ${system}";
  arch = {
    i686-linux = "x86";
  }.${system} or throwSystem;

  src = "${bootstrap-seeds-src}/POSIX/${arch}/kaem-minimal.hex0";
in
runBareCommand "kaem-minimal" hex0 [ src (placeholder "out") ]
