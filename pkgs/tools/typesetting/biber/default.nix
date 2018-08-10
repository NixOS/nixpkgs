{ stdenv, fetchFromGitHub, perlPackages }:

# builds but doesn't work with perl 5.24, see discussion in #40826
# TODO: build with perl >=5.26 and try to enable tests

perlPackages.buildPerlModule rec {
  name = "biber-${version}";
  version = "2.10";

  src = fetchFromGitHub {
    owner = "plk";
    repo = "biber";
    rev = "v${version}";
    sha256 = "0f6bb1iprl92iamxqlr8fc99mxr9n3722frd1ak9pbzh3m6c2ny6";
  };

  buildInputs = with perlPackages; [
    autovivification BusinessISBN BusinessISMN BusinessISSN ConfigAutoConf
    DataCompare DataDump DateSimple EncodeEUCJPASCII EncodeHanExtra EncodeJIS2K
    DateTime DateTimeFormatBuilder DateTimeCalendarJulian
    ExtUtilsLibBuilder FileSlurper FileWhich IPCRun3 LogLog4perl LWPProtocolHttps ListAllUtils
    ListMoreUtils MozillaCA ReadonlyXS RegexpCommon TextBibTeX
    UnicodeCollate UnicodeLineBreak URI XMLLibXMLSimple XMLLibXSLT XMLWriter
    ClassAccessor TextCSV TextCSV_XS TextRoman DataUniqid LinguaTranslit UnicodeNormalize SortKey
    TestDifferences
  ];

  # Tests depend on the precise Unicode-Collate version (expects 1.19, but we have 1.25)
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Backend for BibLaTeX";
    license = with licenses; [ artistic1 gpl1Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.ttuegel ];
  };
}
