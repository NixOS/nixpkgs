{ stdenv, fetchzip, python2Packages }:

python2Packages.buildPythonApplication rec {
  name = "pygmentex-${version}";
  version = "0.8";

  src = fetchzip {
      url = "http://mirrors.ctan.org/macros/latex/contrib/pygmentex.zip";
      sha256 = "1nm19pvhlv51mv2sdankndhw64ys9r7ch6szzd6i4jz8zr86kn9v";
  };

  pythonPath = [ python2Packages.pygments python2Packages.chardet ];

  dontBuild = true;

  doCheck = false;

  installPhase = ''
    mkdir -p $out/bin
    cp -a pygmentex.py $out/bin
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
    maintainers = with maintainers; [ romildo ];
    platforms = platforms.unix;
  };
}
