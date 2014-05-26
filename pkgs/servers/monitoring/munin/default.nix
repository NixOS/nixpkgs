{ stdenv, fetchurl, makeWrapper, which, coreutils, rrdtool, perl, perlPackages
, python, ruby, openjdk, nettools
}:

stdenv.mkDerivation rec {
  version = "2.0.21";
  name = "munin-${version}";

  src = fetchurl {
    url = "https://github.com/munin-monitoring/munin/archive/${version}.tar.gz";
    sha256 = "18ipk8n78iik07190h9r8mj5209ha6yhbiw7da0l4khw0y00cvf8";
  };

  buildInputs = [ 
    makeWrapper
    which
    coreutils
    rrdtool
    nettools
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
    perlPackages.LWPUserAgent
    perlPackages.DBDPg
    python
    ruby
    openjdk
    # tests
    perlPackages.TestLongString
    perlPackages.TestDifferences
    perlPackages.TestDeep
    perlPackages.TestMockModule
    perlPackages.TestMockObject
    perlPackages.FileSlurp
    perlPackages.IOStringy
  ];

  # TODO: tests are failing http://munin-monitoring.org/ticket/1390#comment:1
  # NOTE: important, test command always exits with 0, think of a way to abort the build once tests pass
  doCheck = false;

  checkPhase = ''
   export PERL5LIB="$PERL5LIB:${rrdtool}/lib/perl"
   LC_ALL=C make -j1 test 
  '';

  patches = [
    # https://rt.cpan.org/Public/Bug/Display.html?id=75112
    ./dont_preserve_source_dir_permissions.patch

    # https://github.com/munin-monitoring/munin/pull/134
    ./adding_servicedir_munin-node.patch
  ];

  preBuild = ''
    substituteInPlace "Makefile" \
      --replace "/bin/pwd" "pwd" \
      --replace "HTMLOld.3pm" "HTMLOld.3"

    # munin checks at build time if user/group exists, unpure
    sed -i '/CHECKUSER/d' Makefile
    sed -i '/CHOWN/d' Makefile
    sed -i '/CHECKGROUP/d' Makefile

    # munin hardcodes PATH, we need it to obey $PATH
    sed -i '/ENV{PATH}/d' node/lib/Munin/Node/Service.pm
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
    PLUGINUSER=munin
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
        wrapProgram "$file" \
          --set PERL5LIB "$out/lib/perl5/site_perl:${perlPackages.Log4Perl}/lib/perl5/site_perl:${perlPackages.IOSocketInet6}/lib/perl5/site_perl:${perlPackages.Socket6}/lib/perl5/site_perl:${perlPackages.URI}/lib/perl5/site_perl:${perlPackages.DBFile}/lib/perl5/site_perl:${perlPackages.DateManip}/lib/perl5/site_perl:${perlPackages.HTMLTemplate}/lib/perl5/site_perl:${perlPackages.FileCopyRecursive}/lib/perl5/site_perl:${perlPackages.FCGI}/lib/perl5/site_perl:${perlPackages.NetSNMP}/lib/perl5/site_perl:${perlPackages.NetServer}/lib/perl5/site_perl:${perlPackages.ListMoreUtils}/lib/perl5/site_perl:${perlPackages.TimeHiRes}/lib/perl5/site_perl:${rrdtool}/lib/perl:${perlPackages.DBDPg}/lib/perl5/site_perl:${perlPackages.LWPUserAgent}/lib/perl5/site_perl"
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
