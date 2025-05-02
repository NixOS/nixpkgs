{ lib, stdenv, fetchurl }:

let
  version = "1.11-6";
in stdenv.mkDerivation {
  pname = "quake3-demodata";
  inherit version;

  src = fetchurl {
    url = "https://ftp.gwdg.de/pub/misc/ftp.idsoftware.com/idstuff/quake3/linux/linuxq3ademo-${version}.x86.gz.sh";
    sha256 = "1v54a1hx1bczk9hgn9qhx8vixsy7xn7wj2pylhfjsybfkgvf7pk4";
  };

  buildCommand = ''
    tail -n +165 $src | tar xfz -

    mkdir -p $out/baseq3
    cp demoq3/*.pk3 $out/baseq3
  '';

  preferLocalBuild = true;

  meta = with lib; {
    description = "Quake 3 Arena demo content";
    license = licenses.unfreeRedistributable;
    platforms = platforms.all;
    maintainers = with maintainers; [ abbradar ];
  };
}
