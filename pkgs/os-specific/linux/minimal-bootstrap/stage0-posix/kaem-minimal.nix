{ system
, bootstrap-seeds-src
, hex0
, version
}:
let
  throwSystem = throw "Unsupported system: ${system}";
  arch = {
    i686-linux = "x86";
  }.${system} or throwSystem;

  src = "${bootstrap-seeds-src}/POSIX/${arch}/kaem-minimal.hex0";
in
derivation {
  inherit system;
  name = "kaem-minimal-${version}";
  builder = hex0;
  args = [
    src
    (placeholder "out")
  ];
}

