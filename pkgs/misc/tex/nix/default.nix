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
      
      buildInputs = [ pkgs.tetex ];
    };

    
}