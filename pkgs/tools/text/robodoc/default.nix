{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "robodoc";
  version = "4.99.44";

  src = fetchFromGitHub {
    owner = "gumpu";
    repo = "ROBODoc";
    rev = "v${version}";
    sha256 = "l3prSdaGhOvXmZfCPbsZJNocO7y20zJjLQpajRTJOqE=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  hardeningDisable = [ "format" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://github.com/gumpu/ROBODoc";
    description = "Documentation Extraction Tool";
    longDescription = ''
      ROBODoc is program documentation tool. The idea is to include for every
      function or procedure a standard header containing all sorts of
      information about the procedure or function. ROBODoc extracts these
      headers from the source file and puts them in a separate
      autodocs-file. ROBODoc thus allows you to include the program
      documentation in the source code and avoid having to maintain two separate
      documents. Or as Petteri puts it: "robodoc is very useful - especially for
      programmers who don't like writing documents with Word or some other
      strange tool."

      ROBODoc can format the headers in a number of different formats: HTML,
      RTF, LaTeX, or XML DocBook. In HTML mode it can generate cross links
      between headers. You can even include parts of your source code.

      ROBODoc works with many programming languages: For instance C, Pascal,
      Shell Scripts, Assembler, COBOL, Occam, Postscript, Forth, Tcl/Tk, C++,
      Java -- basically any program in which you can use remarks/comments.
    '';
    license = with licenses; gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; all;
  };
}
