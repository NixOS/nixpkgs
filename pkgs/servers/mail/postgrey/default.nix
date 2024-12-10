{
  fetchurl,
  perlPackages,
  lib,
  runCommand,
  postfix,
}:

let
  mk-perl-flags =
    inputs: lib.concatStringsSep " " (map (dep: "-I ${dep}/${perlPackages.perl.libPrefix}") inputs);
  postgrey-flags = mk-perl-flags (
    with perlPackages;
    [
      NetServer
      BerkeleyDB
      DigestSHA1
      NetAddrIP
      IOMultiplex
    ]
  );
  policy-test-flags = mk-perl-flags (
    with perlPackages;
    [
      ParseSyslog
    ]
  );
  version = "1.37";
  name = "postgrey-${version}";
in
runCommand name
  {
    src = fetchurl {
      url = "https://postgrey.schweikert.ch/pub/${name}.tar.gz";
      sha256 = "1xx51xih4711vrvc6d57il9ccallbljj5zhgqdb07jzmz11rakgz";
    };
    meta = with lib; {
      description = "A postfix policy server to provide greylisting";
      homepage = "https://postgrey.schweikert.ch/";
      platforms = postfix.meta.platforms;
      license = licenses.gpl2;
    };
  }
  ''
    mkdir -p $out/bin
    cd $out
    tar -xzf $src --strip-components=1
    mv postgrey policy-test bin
    sed -i -e "s,#!/usr/bin/perl -T,#!${perlPackages.perl}/bin/perl -T ${postgrey-flags}," \
           -e "s#/etc/postfix#$out#" \
        bin/postgrey
    sed -i -e "s,#!/usr/bin/perl,#!${perlPackages.perl}/bin/perl ${policy-test-flags}," \
        bin/policy-test
  ''
