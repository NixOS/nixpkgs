{ stdenv, fetchgit }:

stdenv.mkDerivation {

  name = "tracefilesim-2015-11-07";
  
  src = fetchgit {
    url = "https://github.com/GarCoSim/TraceFileSim.git";
    rev = "368aa6b1d6560e7ecbd16fca47000c8f528f3da2";
    sha256 = "22dfb60d1680ce6c98d60d12c0d0950073f02359605fcdef625e3049bca07809";
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
