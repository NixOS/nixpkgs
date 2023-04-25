{ system
, src
, hex0
, version
}:
let
  throwSystem = throw "Unsupported system: ${system}";
  arch = {
    i686-linux = "x86";
  }.${system} or throwSystem;

  source = "${src}/bootstrap-seeds/POSIX/${arch}/kaem-minimal.hex0";
in
derivation {
  inherit system;
  name = "kaem-minimal-${version}";
  builder = hex0;
  args = [
    source
    (placeholder "out")
  ];
}

