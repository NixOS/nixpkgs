pkgs:

rec {


  runLaTeX =
    { rootFile
    , generatePDF ? true
    }:
    
    pkgs.stdenv.mkDerivation {
      name = "doc";
      
      builder = ./run-latex.sh;
      copyIncludes = ./copy-includes.pl;
      
      inherit rootFile generatePDF;

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
    };
    
}