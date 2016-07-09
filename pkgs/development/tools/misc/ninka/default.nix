{ stdenv, fetchFromGitHub, perl, perlPackages, buildPerlPackage }:

assert stdenv ? glibc;

buildPerlPackage rec {
  name = "ninka-${version}";
  version = "2.0-pre";

  src = fetchFromGitHub {
    owner = "dmgerman";
    repo = "ninka";
    rev = "b89b59ecd057dfc939d0c75acaddebb58fcd8cba";
    sha256 = "1grlis1kycbcjvjgqvn7aw81q1qx49ahvxg2k7cgyr79mvgpgi9m";
  };
  
  buildInputs = with perlPackages; [ perl TestOutput DBDSQLite DBI TestPod TestPodCoverage SpreadsheetParseExcel ];

  doCheck = false;    # hangs

  preConfigure = ''
    sed -i.bak -e 's;#!/usr/bin/perl;#!${perl}/bin/perl;g' \
        ./bin/ninka-excel ./bin/ninka ./bin/ninka-sqlite \
        ./scripts/unify.pl ./scripts/parseLicense.pl \
        ./scripts/license_matcher_modified.pl \
        ./scripts/sort_package_license_list.pl
    perl Makefile.PL
  '';

  meta = with stdenv.lib; {
    description = "A sentence based license detector";
    homepage = "http://ninka.turingmachine.org/";
    license = licenses.gpl2;
    maintainers = [ maintainers.vrthra ];
    platforms = platforms.all;
  };
}
