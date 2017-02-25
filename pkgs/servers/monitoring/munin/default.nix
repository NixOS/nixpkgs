{ stdenv, fetchFromGitHub, makeWrapper, which, coreutils, rrdtool, perl, perlPackages
, python, ruby, jre, nettools, bc
}:

stdenv.mkDerivation rec {
  version = "2.0.30";
  name = "munin-${version}";

  src = fetchFromGitHub {
    owner = "munin-monitoring";
    repo = "munin";
    rev = version;
    sha256 = "1sxsdfq9a5d8b13jigr06gs7n4m3c95645sfyyl49bkfy0n5cxrg";
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
    perlPackages.NetCIDR
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
    jre
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
   export PERL5LIB="$PERL5LIB:${rrdtool}/lib/perl5/site_perl"
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
    JAVARUN=${jre}/bin/java
    PLUGINUSER=munin
  '';

  postFixup = ''
    echo "Removing references to /usr/{bin,sbin}/ from munin plugins..."
    find "$out/lib/plugins" -type f -print0 | xargs -0 -L1 \
        sed -i -e "s|/usr/bin/||g" -e "s|/usr/sbin/||g" -e "s|\<bc\>|${bc}/bin/bc|g"

    if test -e $out/nix-support/propagated-native-build-inputs; then
        ln -s $out/nix-support/propagated-native-build-inputs $out/nix-support/propagated-user-env-packages
    fi

    for file in "$out"/bin/munindoc "$out"/sbin/munin-* "$out"/lib/munin-* "$out"/www/cgi/*; do
        # don't wrap .jar files
        case "$file" in
            *.jar) continue;;
        esac
        wrapProgram "$file" \
          --set PERL5LIB "$out/lib/perl5/site_perl:${with perlPackages; stdenv.lib.makePerlPath [
                Log4Perl IOSocketInet6 Socket6 URI DBFile DateManip
                HTMLTemplate FileCopyRecursive FCGI NetCIDR NetSNMP NetServer
                ListMoreUtils TimeHiRes DBDPg LWPUserAgent rrdtool
                ]}"
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
    maintainers = [ maintainers.domenkozar maintainers.bjornfor ];
    platforms = platforms.linux;
  };
}
