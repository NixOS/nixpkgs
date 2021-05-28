{ runCommandNoCC, fetchurl, file, texlive }:

{
  chktex = runCommandNoCC "texlive-test-chktex" {
    nativeBuildInputs = [
      (with texlive; combine { inherit scheme-infraonly chktex; })
    ];
    input = builtins.toFile "chktex-sample.tex" ''
      \documentclass{article}
      \begin{document}
        \LaTeX is great
      \end{document}
    '';
  } ''
    chktex -v -nall -w1 "$input" 2>&1 | tee "$out"
    grep "One warning printed" "$out"
  '';

  # https://github.com/NixOS/nixpkgs/issues/75605
  dvipng = runCommandNoCC "texlive-test-dvipng" {
    nativeBuildInputs = [ file texlive.combined.scheme-medium ];
    input = fetchurl {
      name = "test_dvipng.tex";
      url = "http://git.savannah.nongnu.org/cgit/dvipng.git/plain/test_dvipng.tex?id=b872753590a18605260078f56cbd6f28d39dc035";
      sha256 = "1pjpf1jvwj2pv5crzdgcrzvbmn7kfmgxa39pcvskl4pa0c9hl88n";
    };
  } ''
    cp "$input" ./document.tex

    latex document.tex
    dvipng -T tight -strict -picky document.dvi
    for f in document*.png; do
      file "$f" | tee output
      grep PNG output
    done

    mkdir "$out"
    mv document*.png "$out"/
  '';

  # https://github.com/NixOS/nixpkgs/issues/75070
  dvisvgm = runCommandNoCC "texlive-test-dvisvgm" {
    nativeBuildInputs = [ file texlive.combined.scheme-medium ];
    input = builtins.toFile "dvisvgm-sample.tex" ''
      \documentclass{article}
      \begin{document}
        mwe
      \end{document}
    '';
  } ''
    cp "$input" ./document.tex

    latex document.tex
    dvisvgm document.dvi -n -o document_dvi.svg
    cat document_dvi.svg
    file document_dvi.svg | grep SVG

    pdflatex document.tex
    dvisvgm -P document.pdf -n -o document_pdf.svg
    cat document_pdf.svg
    file document_pdf.svg | grep SVG

    mkdir "$out"
    mv document*.svg "$out"/
  '';
}
