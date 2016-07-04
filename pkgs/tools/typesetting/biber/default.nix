{ stdenv, fetchFromGitHub, buildPerlPackage, autovivification, BusinessISBN
, BusinessISMN, BusinessISSN, ConfigAutoConf, DataCompare, DataDump, DateSimple
, EncodeEUCJPASCII, EncodeHanExtra, EncodeJIS2K, ExtUtilsLibBuilder
, FileSlurp, IPCRun3, Log4Perl, LWPProtocolHttps, ListAllUtils, ListMoreUtils
, ModuleBuild, MozillaCA, ReadonlyXS, RegexpCommon, TextBibTeX, UnicodeCollate
, UnicodeLineBreak, URI, XMLLibXMLSimple, XMLLibXSLT, XMLWriter, ClassAccessor
, TextRoman, DataUniqid, TestDifferences, FileWhich, UnicodeNormalize, LinguaTranslit }:

let
  version = "2.5";
  pn = "biblatex-biber";
in
buildPerlPackage {
  name = "biber-${version}";
  version = "2.5";
  src = fetchFromGitHub {
    owner = "plk";
    repo = "biber";
    rev = "v${version}";
    sha256 = "1ldkszsr2n11nib4nvmpvsxmvp0qd9w3lxijyqlf01cfaryjdzgr";
  };

  buildInputs = [
    autovivification BusinessISBN BusinessISMN BusinessISSN ConfigAutoConf
    DataCompare DataDump DateSimple EncodeEUCJPASCII EncodeHanExtra EncodeJIS2K
    ExtUtilsLibBuilder FileSlurp IPCRun3 Log4Perl LWPProtocolHttps ListAllUtils
    ListMoreUtils ModuleBuild MozillaCA ReadonlyXS RegexpCommon TextBibTeX
    UnicodeCollate UnicodeLineBreak URI XMLLibXMLSimple XMLLibXSLT XMLWriter
    ClassAccessor TextRoman DataUniqid TestDifferences FileWhich UnicodeNormalize
    LinguaTranslit
  ];
  preConfigure = "touch Makefile.PL";
  buildPhase = "perl Build.PL --prefix=$out; ./Build build";
  checkPhase = ''
    rm t/utils.t # broken
    ./Build test
  '';
  installPhase = "./Build install";

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Backend for BibLaTeX";
    license = with licenses; [ artistic1 gpl1Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.ttuegel maintainers.vrthra ];
  };
}
