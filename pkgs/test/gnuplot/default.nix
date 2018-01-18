{ runCommand, texlive, gnuplot_full }:

let
  ## For now, only test the tikz terminal since that requires setup-hook to work

  tex = texlive.combine { inherit (texlive) scheme-small; };

  tikz-plot = runCommand "tikz-plot" { nativeBuildInputs = [ gnuplot_full ]; } ''
    gnuplot > $out <<EOF
      set term tikz
      plot sin(x)
    EOF
  '';

  # Ensure gnuplot's tikz files are found and can be successfully used:
  tikz-pdf = runCommand "tikz-pdf" { nativeBuildInputs = [ tex gnuplot_full ]; } ''
    cat > doc.tex << EOF
      \documentclass{article}
      \usepackage{gnuplot-lua-tikz}
      \begin{document}
      \input{${tikz-plot}}
      \end{document}
    EOF
    pdflatex doc.tex
    pdflatex doc.tex

    mv doc.pdf $out
  '';

in tikz-pdf
