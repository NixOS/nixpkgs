{ lib, stdenv, linux }:

stdenv.mkDerivation {
  pname = "vm-tools";
  inherit (linux) version src;

  makeFlags = [ "sbindir=${placeholder "out"}/bin" ];

  preConfigure = "cd tools/vm";

  meta = with lib; {
    inherit (linux.meta) license platforms;
    description = "Set of virtual memory tools";
    maintainers = [ maintainers.evils ];
  };
}
