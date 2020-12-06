{ stdenv, fetchpatch, perlPackages, shortenPerlShebang, texlive }:

let
  biberSource = stdenv.lib.head (builtins.filter (p: p.tlType == "source") texlive.biber.pkgs);
in

perlPackages.buildPerlModule {
  pname = "biber";
  inherit (biberSource) version;

  src = "${biberSource}/source/bibtex/biber/biblatex-biber.tar.gz";

  patches = [
    # Fix for https://github.com/plk/biber/issues/329
    (fetchpatch {
      url = "https://github.com/plk/biber/commit/fa312ce402fe581ba7cc0890c83a1d47c2610e26.diff";
      sha256 = "1j87mdwvx368z9b5x6b72s753hwvrldf2pb42p6hflq5hzkicy50";
    })
  ];

  buildInputs = with perlPackages; [
    autovivification BusinessISBN BusinessISMN BusinessISSN ConfigAutoConf
    DataCompare DataDump DateSimple EncodeEUCJPASCII EncodeHanExtra EncodeJIS2K
    DateTime DateTimeFormatBuilder DateTimeCalendarJulian
    ExtUtilsLibBuilder FileSlurper FileWhich IPCRun3 LogLog4perl LWPProtocolHttps ListAllUtils
    ListMoreUtils MozillaCA ParseRecDescent IOString ReadonlyXS RegexpCommon TextBibTeX
    UnicodeLineBreak URI XMLLibXMLSimple XMLLibXSLT XMLWriter
    ClassAccessor TextCSV TextCSV_XS TextRoman DataUniqid LinguaTranslit SortKey
    TestDifferences
    PerlIOutf8_strict
  ];
  nativeBuildInputs = stdenv.lib.optional stdenv.isDarwin shortenPerlShebang;

  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    shortenPerlShebang $out/bin/biber
  '';

  meta = with stdenv.lib; {
    description = "Backend for BibLaTeX";
    license = with licenses; [ artistic1 gpl1Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.ttuegel ];
  };
}
