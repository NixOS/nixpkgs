{ stdenv, fetchpatch, perlPackages, shortenPerlShebang, texlive }:

let
  biberSource = stdenv.lib.head (builtins.filter (p: p.tlType == "source") texlive.biber.pkgs);
in

perlPackages.buildPerlModule {
  pname = "biber";
  inherit (biberSource) version;

  src = "${biberSource}/source/bibtex/biber/biblatex-biber.tar.gz";

  patches = stdenv.lib.optionals (stdenv.lib.versionAtLeast perlPackages.perl.version "5.30") [
    (fetchpatch {
      name = "biber-fix-tests.patch";
      url = "https://git.archlinux.org/svntogit/community.git/plain/trunk/biber-fix-tests.patch?h=5d0fffd493550e28b2fb81ad114d62a7c9403812";
      sha256 = "1ninf46bxf4hm0p5arqbxqyv8r98xdwab34vvp467q1v23kfbhya";
    })

    (fetchpatch {
      name = "biber-fix-tests-2.patch";
      url = "https://git.archlinux.org/svntogit/community.git/plain/trunk/biber-fix-tests-2.patch?h=5d0fffd493550e28b2fb81ad114d62a7c9403812";
      sha256 = "1l8pk454kkm0szxrv9rv9m2a0llw1jm7ffhgpyg4zfiw246n62x0";
    })
  ];

  buildInputs = with perlPackages; [
    autovivification BusinessISBN BusinessISMN BusinessISSN ConfigAutoConf
    DataCompare DataDump DateSimple EncodeEUCJPASCII EncodeHanExtra EncodeJIS2K
    DateTime DateTimeFormatBuilder DateTimeCalendarJulian
    ExtUtilsLibBuilder FileSlurper FileWhich IPCRun3 LogLog4perl LWPProtocolHttps ListAllUtils
    ListMoreUtils MozillaCA ReadonlyXS RegexpCommon TextBibTeX
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
