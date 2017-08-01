{ stdenv, fetchurl, makeWrapper
, ghostscript, netpbm, perl }:
# TODO: withTex

# Ported from Homebrew.
# https://github.com/Homebrew/homebrew-core/blob/21834573f690407d34b0bbf4250b82ec38dda4d6/Formula/latex2html.rb

stdenv.mkDerivation rec {
  name = "latex2html-${version}";
  version = "2016";

  src = fetchurl {
    url = "http://mirrors.ctan.org/support/latex2html/latex2html-${version}.tar.gz";
    sha256 = "028k0ypbq94mlhydf1sbqlphlfl2fhmlzhgqq5jjzihfmccbq7db";
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
