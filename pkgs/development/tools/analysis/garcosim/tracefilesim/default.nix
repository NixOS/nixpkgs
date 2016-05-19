{ stdenv, fetchgit }:

stdenv.mkDerivation {

  name = "tracefilesim-2015-11-07";

  src = fetchgit {
    url = "https://github.com/GarCoSim/TraceFileSim.git";
    rev = "368aa6b1d6560e7ecbd16fca47000c8f528f3da2";
    sha256 = "156m92k38ap4bzidbr8dzl065rni8lrib71ih88myk9z5y1x5nxm";
  };

  installPhase = ''
    mkdir --parents "$out/bin"
    cp ./traceFileSim "$out/bin"
  '';

  meta = with stdenv.lib; {
    description = "Ease the analysis of existing memory management techniques, as well as the prototyping of new memory management techniques.";
    homepage = "https://github.com/GarCoSim";
    maintainers = [ maintainers.cmcdragonkai ];
    licenses = licenses.gpl2;
    platforms = platforms.linux;
  };

}
