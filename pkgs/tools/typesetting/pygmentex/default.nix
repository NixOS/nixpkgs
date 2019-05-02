{ stdenv, fetchFromBitbucket, python2Packages }:

python2Packages.buildPythonApplication rec {
  pname = "pygmentex";
  version = "0.8";
  tlType = "run";

  src = fetchFromBitbucket {
    owner = "romildo";
    repo = pname;
    rev = version;
    sha256 = "07dnv7hgppy15bda2kcbrlvfqzl6lhza80klc7133dwg8q92hm6m";
  };

  pythonPath = with python2Packages; [ pygments chardet ];

  dontBuild = true;

  doCheck = false;

  installPhase = ''
    mkdir -p $out/bin
    cp -a pygmentex.py $out/bin

    mkdir -p $out/scripts/pygmentex
    ln -s $out/bin/pygmentex.py $out/scripts/pygmentex

    mkdir -p $out/tex/latex/pygmentex
    cp -a pygmentex.sty $out/tex/latex/pygmentex

    mkdir -p $out/doc/latex/pygmentex
    cp -a README demo.* blueshade.png Factorial.java $out/doc/latex/pygmentex
  '';

  meta = with stdenv.lib; {
    homepage = https://www.ctan.org/pkg/pygmentex;
    description = "Auxiliary tool for typesetting code listings in LaTeX documents using Pygments";
    longDescription = ''
      PygmenTeX is a Python-based LaTeX package that can be used for
      typesetting code listings in a LaTeX document using Pygments.

      Pygments is a generic syntax highlighter for general use in all kinds of
      software such as forum systems, wikis or other applications that need to
      prettify source code.

      This package installs just the script needed to process code listings
      snippets extracted from the a LaTeX document by the pygmentex LaTeX
      package. In order to use it effectivelly the texlive package pygmentex
      also has to be installed. This can be done by adding pygmentex to
      texlive.combine.
    '';
    license = licenses.lppl13c;
    platforms = platforms.unix;
    maintainers = with maintainers; [ romildo ];
  };
}
