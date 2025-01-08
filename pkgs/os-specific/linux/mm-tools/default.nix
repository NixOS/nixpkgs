{
  lib,
  stdenv,
  linux,
}:

stdenv.mkDerivation {
  pname = "mm-tools";
  inherit (linux) version src;

  makeFlags = [ "sbindir=${placeholder "out"}/bin" ];

  preConfigure = "cd tools/mm";

  meta = with lib; {
    inherit (linux.meta) license platforms;
    description = "Set of virtual memory tools";
    maintainers = [ maintainers.evils ];
  };
}
