{ stdenv, fetchFromGitHub, perlPackages }:

perlPackages.buildPerlModule rec {
  name = "biber-${version}";
  version = "2.12";

  src = fetchFromGitHub {
    owner = "plk";
    repo = "biber";
    rev = "v${version}";
    sha256 = "1g1hi6zvf2hmrjly1sidjaxy5440gfqm4p7p3n7kayshnjsmlskx";
  };

  buildInputs = with perlPackages; [
    autovivification BusinessISBN BusinessISMN BusinessISSN ConfigAutoConf
    DataCompare DataDump DateSimple EncodeEUCJPASCII EncodeHanExtra EncodeJIS2K
    DateTime DateTimeFormatBuilder DateTimeCalendarJulian
    ExtUtilsLibBuilder FileSlurper FileWhich IPCRun3 LogLog4perl LWPProtocolHttps ListAllUtils
    ListMoreUtils MozillaCA ReadonlyXS RegexpCommon TextBibTeX
    UnicodeLineBreak URI XMLLibXMLSimple XMLLibXSLT XMLWriter
    ClassAccessor TextCSV TextCSV_XS TextRoman DataUniqid LinguaTranslit SortKey
    TestDifferences
  ];

  checkInputs = with perlPackages; [
    UnicodeCollate
  ];

  meta = with stdenv.lib; {
    description = "Backend for BibLaTeX";
    license = with licenses; [ artistic1 gpl1Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.ttuegel ];
  };
}
