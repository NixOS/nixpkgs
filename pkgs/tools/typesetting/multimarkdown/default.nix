{ stdenv, fetchgit, perl }:

stdenv.mkDerivation rec {
  name = "multimarkdown-${version}";
  version = "4.7.1";

  src = fetchgit {
    url = "https://github.com/fletcher/MultiMarkdown-4.git";
    fetchSubmodules = true;
    rev = "dd060247518715ef2b52be22b8f49d0e6d2c3a8b";
    sha256 = "11f246r30q2fx4xw7valhqjj4mc4ydj5fv5f2kbl5h93y69q0bw7";
  };

  preBuild = ''
    substituteInPlace enumsToPerl.pl --replace "/usr/bin/perl" "${perl}/bin/perl"
  '';

  buildInputs = [ stdenv ];
  checkPhase = "make test-all";
  installPhase = "make pkg-install prefix='' DESTDIR=$out; make pkg-install-scripts prefix='' DESTDIR=$out";

  meta = with stdenv.lib; {
    description = "A derivative of Markdown that adds new syntax features";
    longDescription = ''
      MultiMarkdown is a lightweight markup language created by
      Fletcher T. Penney and based on Markdown, which supports
      more export-formats (html, latex, beamer, memoir, odf, opml,
      lyx, mmd) and implements some added features currently not
      available with plain Markdown syntax.

      It adds the following features to Markdown:

      footnotes
      tables
      citations and bibliography (works best in LaTeX using BibTeX)
      math support
      automatic cross-referencing ability
      smart typography, with support for multiple languages
      image attributes
      table and image captions
      definition lists
      glossary entries (LaTeX only)
      document metadata (e.g. title, author, date, etc.)
    '';
    homepage = "http://fletcherpenney.net/multimarkdown/";
    # licensed under GPLv2+ or MIT:
    # https://raw.githubusercontent.com/fletcher/MultiMarkdown-4/master/LICENSE
    license = with stdenv.lib.licenses; [ gpl2Plus ];
    platforms = platforms.all;
    maintainers = with stdenv.lib.maintainers; [ lowfatcomputing ];
  };
}
