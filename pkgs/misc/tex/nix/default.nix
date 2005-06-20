pkgs:

rec {


  runLaTeX =
    { rootFile
    , generatePDF ? true
    }:
    
    pkgs.stdenv.mkDerivation {
      name = "doc";
      builder = ./run-latex.sh;
      
      inherit rootFile generatePDF;

      includes = import (findLaTeXIncludes {inherit rootFile;});
      
      buildInputs = [ pkgs.tetex ];
    };

    
  findLaTeXIncludes =
    { rootFile
    }:

    derivation {
      inherit (pkgs) stdenv;
      
      name = "latex-includes";
      system = pkgs.stdenv.system;
      
      builder = (pkgs.perl ~ /bin/perl);
      args = [ ./find-includes.pl ];

      rootFile = toString rootFile; # !!! hacky
    };     
    
}