pkgs:

rec {


  runLaTeX =
    { rootFile
    , generatePDF ? true
    , extraFiles ? []
    , compressBlanksInIndex ? true
    }:
    
    pkgs.stdenv.mkDerivation {
      name = "doc";
      
      builder = ./run-latex.sh;
      copyIncludes = ./copy-includes.pl;
      
      inherit rootFile generatePDF extraFiles
        compressBlanksInIndex;

      includes = import (findLaTeXIncludes {inherit rootFile;});
      
      buildInputs = [ pkgs.tetex pkgs.perl ];
    };

    
  findLaTeXIncludes =
    { rootFile
    }:

    pkgs.stdenv.mkDerivation {
      name = "latex-includes";

      realBuilder = pkgs.perl ~ "bin/perl";
      args = [ ./find-includes.pl ];

      rootFile = toString rootFile; # !!! hacky

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
