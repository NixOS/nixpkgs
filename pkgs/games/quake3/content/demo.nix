{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "1.11-6";
in
stdenv.mkDerivation {
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
    description = "Demo of Quake 3 Arena, a classic first-person shooter";
    longDescription = ''
      Quake III Arena and it's demo don't offer current wide screen resolutions in the menu.

      To switch to such a resolution, you will have to enter something like this in the quake console (invoke with ~ by default)

      r_mode -1; r_customwidth 2560; r_customheight 1440; r_fullscreen 1; vid_restart

      Or call the quake commandline with these parameters

      $ quake3 +set r_mode -1 +set r_customwidth 2560 +set r_customheight 1440 +set r_fullscreen 1
    '';
    homepage = "https://www.idsoftware.com/";
    license = licenses.unfreeRedistributable;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
