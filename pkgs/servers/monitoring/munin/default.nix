{ stdenv, fetchurl, makeWrapper, which, coreutils, rrdtool, perl, perlPackages
, python, ruby, openjdk }:

# TODO: split into server/node derivations

# FIXME: munin tries to write log files and web graphs to its installation path.

stdenv.mkDerivation rec {
  version = "2.0.17";
  name = "munin-${version}";

  src = fetchurl {
    url = "https://github.com/munin-monitoring/munin/archive/${version}.tar.gz";
    sha256 = "0xfml2r6nssn3lcfqcf3yshxfijyrf9frnhdp83mg6raaznlhx1z";
  };

  buildInputs = [ 
    makeWrapper
    which
    coreutils
    rrdtool
    perl
    perlPackages.ModuleBuild
    perlPackages.HTMLTemplate
    perlPackages.NetSSLeay
    perlPackages.NetServer
    perlPackages.Log4Perl
    perlPackages.IOSocketInet6
    perlPackages.Socket6
    perlPackages.URI
    perlPackages.DBFile
    perlPackages.DateManip
    perlPackages.FileCopyRecursive
    perlPackages.FCGI
    perlPackages.NetSNMP
    perlPackages.NetServer
    perlPackages.ListMoreUtils
    perlPackages.TimeHiRes
    python
    ruby
    openjdk
  ];

  preBuild = ''
    sed -i '/CHECKUSER/d' Makefile
    sed -i '/CHOWN/d' Makefile
    sed -i '/CHECKGROUP/d' Makefile
    substituteInPlace "Makefile" \
      --replace "/usr/pwd" "pwd"
  '';

  # DESTDIR shouldn't be needed (and shouldn't have worked), but munin
  # developers have forgotten to use PREFIX everywhere, so we use DESTDIR to
  # ensure that everything is installed in $out.
  makeFlags = ''
    PREFIX=$(out)
    DESTDIR=$(out)
    PERLLIB=$(out)/lib/perl5/site_perl
    PERL=${perl}/bin/perl
    PYTHON=${python}/bin/python
    RUBY=${ruby}/bin/ruby
    JAVARUN=${openjdk}/bin/java
    HOSTNAME=default
  '';

  postFixup = ''
    if test -e $out/nix-support/propagated-native-build-inputs; then
        ln -s $out/nix-support/propagated-native-build-inputs $out/nix-support/propagated-user-env-packages
    fi

    # TODO: toPerlLibPath can be added to
    # pkgs/development/interpreters/perl5.16/setup-hook.sh (and the other perl
    # versions) just like for python. NOTE: it causes massive rebuilds.
    # $(toPerlLibPath $out perlPackages.Log4Perl ...)

    for file in "$out"/bin/munindoc "$out"/sbin/munin-* "$out"/lib/munin-* "$out"/www/cgi/*; do
        # don't wrap .jar files
        case "$file" in
            *.jar) continue;;
        esac
        wrapProgram "$file" --set PERL5LIB $out/lib/perl5/site_perl:${perlPackages.Log4Perl}/lib/perl5/site_perl:${perlPackages.IOSocketInet6}/lib/perl5/site_perl:${perlPackages.Socket6}/lib/perl5/site_perl:${perlPackages.URI}/lib/perl5/site_perl:${perlPackages.DBFile}/lib/perl5/site_perl:${perlPackages.DateManip}/lib/perl5/site_perl:${perlPackages.HTMLTemplate}/lib/perl5/site_perl:${perlPackages.FileCopyRecursive}/lib/perl5/site_perl:${perlPackages.FCGI}/lib/perl5/site_perl:${perlPackages.NetSNMP}/lib/perl5/site_perl:${perlPackages.NetServer}/lib/perl5/site_perl:${perlPackages.ListMoreUtils}/lib/perl5/site_perl:${perlPackages.TimeHiRes}/lib/perl5/site_perl:${rrdtool}/lib/perl
    done
  '';

  meta = with stdenv.lib; {
    description = "Networked resource monitoring tool";
    longDescription = ''
      Munin is a monitoring tool that surveys all your computers and remembers
      what it saw. It presents all the information in graphs through a web
      interface. Munin can help analyze resource trends and 'what just happened
      to kill our performance?' problems.
    '';
    homepage = http://munin-monitoring.org/;
    license = licenses.gpl2;
    maintainers = [ maintainers.iElectric maintainers.bjornfor ];
    platforms = platforms.linux;
  };
}
