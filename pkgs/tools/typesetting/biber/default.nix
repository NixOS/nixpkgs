{ lib, stdenv, fetchurl, perlPackages, shortenPerlShebang, texlive }:

let
  biberSource = lib.head (builtins.filter (p: p.tlType == "source") texlive.biber.pkgs);

  # perl 5.32.0 ships with U:C 1.27
  UnicodeCollate_1_29 = perlPackages.buildPerlPackage rec {
    pname = "Unicode-Collate";
    version = "1.29";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SA/SADAHIRO/${pname}-${version}.tar.gz";
      sha256 = "0dr4k10fgbsczh4sz7w8d0nnba38r6jrg87cm3gw4xxgn55fzj7l";
    };
    meta = {
      description = "Unicode Collation Algorithm";
      license = perlPackages.perl.meta.license;
    };
  };
in

perlPackages.buildPerlModule {
  pname = "biber";
  inherit (biberSource) version;

  src = "${biberSource}/source/bibtex/biber/biblatex-biber.tar.gz";

  buildInputs = with perlPackages; [
    autovivification BusinessISBN BusinessISMN BusinessISSN ConfigAutoConf
    DataCompare DataDump DateSimple EncodeEUCJPASCII EncodeHanExtra EncodeJIS2K
    DateTime DateTimeFormatBuilder DateTimeCalendarJulian
    ExtUtilsLibBuilder FileSlurper FileWhich IPCRun3 LogLog4perl LWPProtocolHttps ListAllUtils
    ListMoreUtils MozillaCA ParseRecDescent IOString ReadonlyXS RegexpCommon TextBibTeX
    UnicodeCollate_1_29 UnicodeLineBreak URI XMLLibXMLSimple XMLLibXSLT XMLWriter
    ClassAccessor TextCSV TextCSV_XS TextRoman DataUniqid LinguaTranslit SortKey
    TestDifferences
    PerlIOutf8_strict
  ];
  nativeBuildInputs = lib.optional stdenv.isDarwin shortenPerlShebang;

  postInstall = lib.optionalString stdenv.isDarwin ''
    shortenPerlShebang $out/bin/biber
  '';

  meta = with lib; {
    description = "Backend for BibLaTeX";
    license = with licenses; [ artistic1 gpl1Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.ttuegel ];
  };
}
