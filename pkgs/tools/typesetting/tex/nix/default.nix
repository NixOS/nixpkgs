pkgs:

rec {

  runLaTeX =
    {
      rootFile,
      generatePDF ? true, # generate PDF, not DVI
      generatePS ? false, # generate PS in addition to DVI
      extraFiles ? [ ],
      compressBlanksInIndex ? true,
      packages ? [ ],
      texPackages ? { },
      copySources ? false,
    }:

    assert generatePDF -> !generatePS;

    let
      tex =
        pkgs.texlive.combine
          # always include basic stuff you need for LaTeX
          ({ inherit (pkgs.texlive) scheme-basic; } // texPackages);
    in

    pkgs.stdenv.mkDerivation {
      name = "doc";

      builder = ./run-latex.sh;
      copyIncludes = ./copy-includes.pl;

      inherit
        rootFile
        generatePDF
        generatePS
        extraFiles
        compressBlanksInIndex
        copySources
        ;

      includes =
        map
          (x: [
            x.key
            (baseNameOf (toString x.key))
          ])
          (findLaTeXIncludes {
            inherit rootFile;
          });

      buildInputs = [
        tex
        pkgs.perl
      ] ++ packages;
    };

  # Returns the closure of the "dependencies" of a LaTeX source file.
  # Dependencies are other LaTeX source files (e.g. included using
  # \input{}), images (e.g. \includegraphics{}), bibliographies, and
  # so on.
  findLaTeXIncludes =
    {
      rootFile,
    }:

    builtins.genericClosure {
      startSet = [ { key = rootFile; } ];

      operator =
        { key, ... }:

        let

          # `find-includes.pl' returns the dependencies of the current
          # source file (`key') as a list, e.g. [{type = "tex"; name =
          # "introduction.tex";} {type = "img"; name = "example"}].
          # The type denotes the kind of dependency, which determines
          # what extensions we use to look for it.
          deps = import (
            pkgs.runCommand "latex-includes" {
              rootFile = baseNameOf (toString rootFile);
              src = key;
            } "${pkgs.perl}/bin/perl ${./find-includes.pl}"
          );

          # Look for the dependencies of `key', trying various
          # extensions determined by the type of each dependency.
          # TODO: support a search path.
          foundDeps =
            dep: xs:
            let
              exts =
                if dep.type == "img" then
                  [
                    ".pdf"
                    ".png"
                    ".ps"
                    ".jpg"
                  ]
                else if dep.type == "tex" then
                  [
                    ".tex"
                    ""
                  ]
                else
                  [ "" ];
              fn = pkgs.lib.findFirst (fn: builtins.pathExists fn) null (
                map (ext: dirOf key + ("/" + dep.name + ext)) exts
              );
            in
            if fn != null then [ { key = fn; } ] ++ xs else xs;

        in
        pkgs.lib.foldr foundDeps [ ] deps;
    };

  findLhs2TeXIncludes =
    {
      lib,
      rootFile,
    }:

    builtins.genericClosure {
      startSet = [ { key = rootFile; } ];

      operator =
        { key, ... }:

        let

          deps = import (
            pkgs.runCommand "lhs2tex-includes" {
              src = key;
            } "${pkgs.stdenv.bash}/bin/bash ${./find-lhs2tex-includes.sh}"
          );

        in
        pkgs.lib.concatMap (x: lib.optionals (builtins.pathExists x) [ { key = x; } ]) (
          map (x: dirOf key + ("/" + x)) deps
        );
    };

  dot2pdf =
    {
      dotGraph,
    }:

    pkgs.stdenv.mkDerivation {
      name = "pdf";
      builder = ./dot2pdf.sh;
      inherit dotGraph fontsConf;
      buildInputs = [
        pkgs.perl
        pkgs.graphviz
      ];
    };

  dot2ps =
    {
      dotGraph,
    }:

    pkgs.stdenv.mkDerivation {
      name = "ps";
      builder = ./dot2ps.sh;
      inherit dotGraph;
      buildInputs = [
        pkgs.perl
        pkgs.graphviz
        pkgs.ghostscript
      ];
    };

  lhs2tex =
    {
      source,
      flags ? null,
    }:
    pkgs.stdenv.mkDerivation {
      name = "tex";
      builder = ./lhs2tex.sh;
      inherit source flags;
      buildInputs = [
        pkgs.lhs2tex
        pkgs.perl
      ];
      copyIncludes = ./copy-includes.pl;
      includes =
        map
          (x: [
            x.key
            (baseNameOf (toString x.key))
          ])
          (findLhs2TeXIncludes {
            rootFile = source;
          });
    };

  animateDot =
    dotGraph: nrFrames:
    pkgs.stdenv.mkDerivation {
      name = "dot-frames";
      builder = ./animatedot.sh;
      inherit dotGraph nrFrames;
    };

  # Wrap a piece of TeX code in a document.  Useful when generating
  # inline images from TeX code.
  wrapSimpleTeX =
    {
      preamble ? null,
      body,
      name ? baseNameOf (toString body),
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
    {
      postscript,
    }:

    pkgs.stdenv.mkDerivation {
      name = "png";
      inherit postscript;

      buildInputs = [
        pkgs.imagemagick
        pkgs.ghostscript
      ];

      buildCommand = ''
        if test -d $postscript; then
          input=$(ls $postscript/*.ps)
        else
          input=$(stripHash $postscript)
          ln -s $postscript $input
        fi

        mkdir -p $out
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
    {
      preamble ? null,
      body,
      packages ? [ ],
    }:

    postscriptToPNG {
      postscript = runLaTeX {
        rootFile = wrapSimpleTeX {
          inherit body preamble;
        };
        inherit packages;
        generatePDF = false;
        generatePS = true;
      };
    };

  # Convert a piece of TeX code to a PDF.
  simpleTeXToPDF =
    {
      preamble ? null,
      body,
      packages ? [ ],
    }:

    runLaTeX {
      rootFile = wrapSimpleTeX {
        inherit body preamble;
      };
      inherit packages;
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
