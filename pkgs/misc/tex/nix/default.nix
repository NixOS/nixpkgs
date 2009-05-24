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
    , copySources ? false
    }:

    assert generatePDF -> !generatePS;
    
    pkgs.stdenv.mkDerivation {
      name = "doc";
      
      builder = ./run-latex.sh;
      copyIncludes = ./copy-includes.pl;
      
      inherit rootFile generatePDF generatePS extraFiles
        compressBlanksInIndex copySources;

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
      hack = builtins.currentTime;
    };


  dot2pdf =
    { dotGraph
    }:

    pkgs.stdenv.mkDerivation {
      name = "pdf";
      builder = ./dot2pdf.sh;
      inherit dotGraph fontsConf;
      buildInputs = [
        pkgs.perl pkgs.tetex pkgs.graphviz
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


  # Wrap a piece of TeX code in a document.  Useful when generating
  # inline images from TeX code.
  wrapSimpleTeX =
    { preamble ? null
    , body
    , name ? baseNameOf (toString body)
    }:

    pkgs.stdenv.mkDerivation {
      inherit name preamble body;
      buildCommand = ''
        touch $out
        echo '\documentclass{article}' >> $out
        echo '\pagestyle{empty}' >> $out
        if test -n "$preamble"; then cat $preamble >> $out; fi
        echo '\begin{document}' >> $out
        cat $body >> $out
        echo '\end{document}' >> $out
      '';
    };


  # Convert a Postscript file to a PNG image, trimming it so that
  # there is no unnecessary surrounding whitespace.    
  postscriptToPNG =
    { postscript
    }:

    pkgs.stdenv.mkDerivation {
      name = "png";
      inherit postscript;

      buildInputs = [pkgs.imagemagick pkgs.ghostscript];
      
      buildCommand = ''
        if test -d $postscript; then
          input=$(ls $postscript/*.ps)
        else
          input=$(stripHash $postscript; echo $strippedName)
          ln -s $postscript $input
        fi

        ensureDir $out
        convert -units PixelsPerInch \
          -density 600 \
          -trim \
          -matte \
          -transparent '#ffffff' \
          -type PaletteMatte \
          +repage \
          $input \
          "$out/$(basename $input .ps).png"
      ''; # */
    };


  # Convert a piece of TeX code to a PNG image.
  simpleTeXToPNG =
    { preamble ? null
    , body
    , name ? baseNameOf (toString body)
    , packages ? []
    }:

    postscriptToPNG {
      postscript = runLaTeX {
        rootFile = wrapSimpleTeX {
          inherit body preamble;
        };
        inherit packages;
        generatePDF = false;
        generatePS = true;
        searchRelativeTo = dirOf (toString body);
      };
    };


  # Convert a piece of TeX code to a PDF.
  simpleTeXToPDF =
    { preamble ? null
    , body
    , name ? baseNameOf (toString body)
    , packages ? []
    }:

    runLaTeX {
      rootFile = wrapSimpleTeX {
        inherit body preamble;
      };
      inherit packages;
      searchRelativeTo = dirOf (toString body);
    };


  # Some tools (like dot) need a fontconfig configuration file.
  # This should be extended to allow the called to add additional
  # fonts.
  fontsConf = pkgs.makeFontsConf {
    fontDirectories = [
      "${pkgs.ghostscript}/share/ghostscript/fonts"
    ];
  };
  
}
