{ stdenv, fetchFromGitHub, makeWrapper
, ghostscript, netpbm, perl }:
# TODO: withTex

stdenv.mkDerivation rec {
  pname = "latex2html";
  version = "2019.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1bcdhbaxf334wlxzkw5samj2y2q173709y0km3x8xs4bbh70ds6c";
  };

  buildInputs = [ ghostscript netpbm perl ];

  nativeBuildInputs = [ makeWrapper ];

  configurePhase = ''
    ./configure \
      --prefix="$out" \
      --without-mktexlsr \
      --with-texpath=$out/share/texmf/tex/latex/html
  '';

  postInstall = ''
    for p in $out/bin/{latex2html,pstoimg}; do \
      wrapProgram $p --add-flags '--tmp="''${TMPDIR:-/tmp}"'
    done
  '';

  meta = with stdenv.lib; {
    description = "LaTeX-to-HTML translator";
    longDescription = ''
      A Perl program that translates LaTeX into HTML (HyperText Markup
      Language), optionally creating separate HTML files corresponding to each
      unit (e.g., section) of the document. LaTeX2HTML proceeds by interpreting
      LaTeX (to the best of its abilities). It contains definitions from a wide
      variety of classes and packages, and users may add further definitions by
      writing Perl scripts that provide information about class/package
      commands.
    '';

    homepage = https://www.ctan.org/pkg/latex2html;

    license = licenses.gpl2;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ yurrriq ];
  };
}
