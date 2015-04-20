{ stdenv, lib, fetchFromGitHub, pkgconfig, which, bison, flex, procps
, ncurses, python, cyrus_sasl, readline, libmicrohttpd, qt4, libmad, cairo, perl, sysstat
, rrdtool
, libpfm, libibumad, libibmad, xdpyinfo, nssTools, nspr, nss
, npapi_sdk
, perlPackages
}:

stdenv.mkDerivation rec {
  name = "pcp-${version}";
  version = "3.10.4";
  src = fetchFromGitHub {
    owner = "performancecopilot";
    repo = "pcp";
    rev = "3.10.4";
    sha256 = "12wkj19r9jydjzc52q5sx7mgwgvg279wnvf2wmf2s2yqrgzcaqrk";
  };
  patches = [
    ./configure.patch
  ];
  postPatch = ''
    find . -executable -type f -exec sed -i -e 's|/var/tmp/pcp.XXXXXXXXX|/tmp/pcp.XXXXXXXXX|' {}  \;
    substituteInPlace configure \
      --replace "@PCP_PS_HAVE_BSD@" false \
      --replace "@PCP_PS_ALL_FLAGS@" "-efw"
  '';
  preConfigure = ''
    export PCP_DIR=$out
    export MAKE=$(which make)
  '';
  postInstall = ''
    xtra=`grep '^PCP_BIN' $PCP_DIR/etc/pcp.conf | sed -e 's/.*=//' | paste -s -d :`
    PATH=$xtra:$PATH
    export PERL5LIB=$PCP_DIR/usr/lib/perl5:$PCP_DIR/usr/share/perl5:$PERL5LIB
    # TODO: loop through PMDAs and run `Install`
  '';
  buildInputs = [
    bison flex procps
    pkgconfig which
    ncurses python cyrus_sasl readline libmicrohttpd qt4 libmad cairo sysstat
    libpfm libibumad libibmad xdpyinfo nssTools nspr nss
    npapi_sdk
    perl rrdtool
    perlPackages.ExtUtilsMakeMaker
    perlPackages.XMLTokeParser
    perlPackages.TimeHiRes
    perlPackages.JSON
    perlPackages.TimeDate
    perlPackages.SpreadsheetWriteExcel
    perlPackages.TextCSV_XS
    perlPackages.SpreadsheetXLSX
  ];
  meta = with lib; {
    description = ''
      Provides a range of services that may be used to monitor and manage system
      performance
    '';
    homepage    = "http://pcp.io";
    maintainers = with maintainers; [ cstrahan ];
    platforms   = platforms.linux;
  };
}
