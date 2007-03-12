pkgs:

rec {


  runLaTeX =
    { rootFile
    , generatePDF ? true # generate PDF, not DVI
    , generatePS ? false # generate PS in addition to DVI
    , extraFiles ? []
    , compressBlanksInIndex ? true
    , packages ? []
    , searchRelativeTo ? dirOf (toString rootFile) # !!! duplication
    }:

    assert generatePDF -> !generatePS;
    
    pkgs.stdenv.mkDerivation {
      name = "doc";
      
      builder = ./run-latex.sh;
      copyIncludes = ./copy-includes.pl;
      
      inherit rootFile generatePDF generatePS extraFiles
        compressBlanksInIndex;

      includes = import (findLaTeXIncludes {inherit rootFile searchRelativeTo;});
      
      buildInputs = [ pkgs.tetex pkgs.perl ] ++ packages;
    };

    
  findLaTeXIncludes =
    { rootFile
    , searchRelativeTo ? dirOf (toString rootFile)
    }:

    pkgs.stdenv.mkDerivation {
      name = "latex-includes";

      realBuilder = pkgs.perl + "/bin/perl";
      args = [ ./find-includes.pl ];

      rootFile = toString rootFile; # !!! hacky

      inherit searchRelativeTo;

      # Forces rebuilds.
      hack = __currentTime;
    };


  dot2pdf =
    { dotGraph
    }:

    pkgs.stdenv.mkDerivation {
      name = "pdf";
      builder = ./dot2pdf.sh;
      inherit dotGraph;
      buildInputs = [
        pkgs.perl pkgs.tetex pkgs.graphviz pkgs.ghostscript
      ];
    };
  

  dot2ps =
    { dotGraph
    }:

    pkgs.stdenv.mkDerivation {
      name = "ps";
      builder = ./dot2ps.sh;
      inherit dotGraph;
      buildInputs = [
        pkgs.perl pkgs.tetex pkgs.graphviz pkgs.ghostscript
      ];
    };

  
  animateDot = dotGraph: nrFrames: pkgs.stdenv.mkDerivation {
    name = "dot-frames";
    builder = ./animatedot.sh;
    inherit dotGraph nrFrames;
  };

}
