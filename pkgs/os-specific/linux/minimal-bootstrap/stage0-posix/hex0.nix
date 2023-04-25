{ system
, bootstrap-seeds-src
, version
}:
let
  throwSystem = throw "Unsupported system: ${system}";
  arch = {
    i686-linux = "x86";
  }.${system} or throwSystem;

  seed = "${bootstrap-seeds-src}/POSIX/${arch}/hex0-seed";
  src = "${bootstrap-seeds-src}/POSIX/${arch}/hex0_${arch}.hex0";
in
derivation {
  inherit system;
  name = "hex0-${version}";
  builder = seed;
  args = [
    src
    (placeholder "out")
  ];
}
