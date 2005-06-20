pkgs:

rec {


  runLaTeX =
    { rootFile
    , generatePDF ? true
    , extraFiles ? []
    }:
    
    pkgs.stdenv.mkDerivation {
      name = "doc";
      
      builder = ./run-latex.sh;
      copyIncludes = ./copy-includes.pl;
      
      inherit rootFile generatePDF extraFiles;

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
  
       
}