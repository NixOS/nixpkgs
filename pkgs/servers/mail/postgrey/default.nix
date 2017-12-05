{ stdenv, fetchurl, perl, perlPackages, lib, runCommand, postfix }:

let
    mk-perl-flags = inputs: lib.concatStringsSep " " (map (dep: "-I ${dep}/lib/perl5/site_perl") inputs);
    postgrey-flags = mk-perl-flags (with perlPackages; [
      NetServer BerkeleyDB DigestSHA1 NetAddrIP IOMultiplex
    ]);
    policy-test-flags = mk-perl-flags (with perlPackages; [
      ParseSyslog
    ]);
    version = "1.36";
    name = "postgrey-${version}";
in runCommand name {
  src = fetchurl {
    url = "http://postgrey.schweikert.ch/pub/${name}.tar.gz";
    sha256 = "09jzb246ki988389r9gryigriv9sravk40q75fih5n0q4p2ghax2";
  };
  meta = with stdenv.lib; {
    description = "A postfix policy server to provide greylisting";
    homepage = https://postgrey.schweikert.ch/;
    platforms = postfix.meta.platforms;
    licenses = licenses.gpl2;
  };
} ''
    mkdir -p $out/bin
    cd $out
    tar -xzf $src --strip-components=1
    mv postgrey policy-test bin
    sed -i -e "s,#!/usr/bin/perl -T,#!${perl}/bin/perl -T ${postgrey-flags}," \
           -e "s#/etc/postfix#$out#" \
        bin/postgrey
    sed -i -e "s,#!/usr/bin/perl,#!${perl}/bin/perl ${policy-test-flags}," \
        bin/policy-test
''
