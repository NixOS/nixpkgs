{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "1.32b-3";
in
stdenv.mkDerivation {
  pname = "quake3-pointrelease";
  inherit version;

  src = fetchurl {
    url = "https://ftp.gwdg.de/pub/misc/ftp.idsoftware.com/idstuff/quake3/linux/linuxq3apoint-${version}.x86.run";
    sha256 = "11piyksfqyxwl9mpgbc71w9sacsh4d3cdsgia0cy0dbbap2k4qf3";
  };

  buildCommand = ''
    sh $src --tar xf

    mkdir -p $out/baseq3
    cp baseq3/*.pk3 $out/baseq3
  '';

  meta = with lib; {
    description = "Quake 3 Arena point release";
    license = licenses.unfreeRedistributable;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
