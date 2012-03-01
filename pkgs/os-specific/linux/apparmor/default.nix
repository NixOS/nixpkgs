{ stdenv, fetchurl
, autoconf, automake, libtool, makeWrapper
, perl, bison, flex, glibc, gettext, which, rpm, tetex, LocaleGettext, bash, pam, TermReadKey, RpcXML, swig}:
stdenv.mkDerivation rec {

  name = "apparmor-${version}";
  version = "2.6.1";

  src = fetchurl {
    url = "http://launchpad.net/apparmor/2.6/2.6.1/+download/${name}.tar.gz";
    sha256 = "1x7225xgzyc5agbn41xsip236anr1kmaw70xc94pag82q7c1bc4w";
  };

  buildInputs = [ autoconf automake libtool perl bison flex gettext which rpm tetex LocaleGettext pam TermReadKey RpcXML swig makeWrapper ];

  prePatch = ''
    substituteInPlace libraries/libapparmor/src/Makefile.in --replace "/usr/include" "${glibc}/include"
    substituteInPlace libraries/libapparmor/src/Makefile.am --replace "/usr/include" "${glibc}/include"
    substituteInPlace common/Make.rules --replace "/usr/bin/pod2man" "${perl}/bin/pod2man"
    substituteInPlace common/Make.rules --replace "/usr/bin/pod2html" "${perl}/bin/pod2html"

    substituteInPlace parser/Makefile --replace "/usr/bin/bison" "${bison}/bin/bison"
    substituteInPlace parser/Makefile --replace "/usr/bin/flex" "${flex}/bin/flex"
    substituteInPlace parser/Makefile --replace "/usr/include/bits/socket.h" "${glibc}/include/bits/socket.h"
    substituteInPlace parser/Makefile --replace "/usr/include/linux/capability.h" "${glibc}/include/linux/capability.h"

    substituteInPlace parser/tst/gen-xtrans.pl --replace "/usr/bin/perl" "${perl}/bin/perl"
    substituteInPlace parser/tst/Makefile --replace "/usr/bin/prove" "${perl}/bin/prove"
    substituteInPlace parser/tst/Makefile --replace "./caching.sh" "${bash}/bin/bash ./caching.sh"
  '';

  buildPhase =''
    PERL5LIB=$PERL5LIB:$out/lib/perl5/site_perl:$out/lib

    cd libraries/libapparmor
    ./autogen.sh
    ./configure --prefix=$out --with-perl	# see below
    make
    make check
    make install
    ensureDir $out/lib/perl5/site_perl/
    cp swig/perl/LibAppArmor.pm $out/lib/perl5/site_perl/
    cp swig/perl/LibAppArmor.bs $out/lib/perl5/site_perl/
# this is automatically copied elsewhere....

    cd ../../utils
    make
    make install DESTDIR=$out BINDIR=$out/bin VENDOR_PERL=/lib/perl5/site_perl

    cd ../parser
    make
    make install DESTDIR=$out DISTRO=unknown

#    cd ../changehat/mod_apparmor
#    make		# depends on libapparmor having been built first
#    make install

    cd ../changehat/pam_apparmor
    make		# depends on libapparmor having been built first
    make install DESTDIR=$out

    cd ../../profiles
LD_LIBRARY_PATH=$out/lib    make
#LD_LIBRARY_PATH=$out/lib    make check	# depends on the parser having been built first
    make install DESTDIR=$out

  '';
  installPhase = ''
    for i in $out/bin/*;  do
      wrapProgram $i --prefix PERL5LIB : "$PERL5LIB:$out/lib/perl5/5.10.1/i686-linux-thread-multi/"
    done
  '';
  passthru = {
    linux_2_6_37_patch = {
      name= "apparmor";
      features.apparmor = true;
      patch = [
	"${src}/kernel-patches/2.6.37/0001-AppArmor-compatibility-patch-for-v5-network-controll.patch"
	"${src}/kernel-patches/2.6.37/0002-AppArmor-compatibility-patch-for-v5-interface.patch"
	"${src}/kernel-patches/2.6.37/0003-AppArmor-Allow-dfa-backward-compatibility-with-broke.patch"
      ];
    };
  };

  meta = with stdenv.lib; {
    homepage = http://apparmor.net/;
    description = "A Linux application security system";
    license = licenses.gpl2;
    maintainers = [ maintainers.phreedom ];
    platforms = platforms.linux;
  };
}

