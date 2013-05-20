{ stdenv, fetchurl, perl, perlPackages, makeWrapper, which }:

# TODO: split into server/node derivations

stdenv.mkDerivation rec {
  version = "2.0.14";
  name = "munin-${version}";

  src = fetchurl {
    url = "https://github.com/munin-monitoring/munin/archive/${version}.tar.gz";
    md5 = "f43f54cb38a64f6f1388c9cbac0395ee";
  };

  buildInputs = [ 
    makeWrapper
    which
    perlPackages.ModuleBuild
  ];

  propagatedBuildInputs = [
    perl
    perlPackages.HTMLTemplate
    perlPackages.NetSSLeay
    perlPackages.NetServer
    perlPackages.Log4Perl
    #perlPackages.TimeHiRes
    # TODO: Net::SNMP
  ];

  makeFlags="PERL=${perl}/bin/perl DESTDIR=$(out) PREFIX=$(out)";

  preBuild = ''
    sed -i '/CHECKUSER/d' Makefile
    sed -i '/CHOWN/d' Makefile
    sed -i '/CHECKGROUP/d' Makefile
    substituteInPlace "Makefile" \
      --replace "/usr/pwd" "pwd"
  '';

  postFixup = ''
    if test -e $out/nix-support/propagated-native-build-inputs; then
        ln -s $out/nix-support/propagated-native-build-inputs $out/nix-support/propagated-user-env-packages
    fi
  '';

  meta = with stdenv.lib; {
    description = "Munin is a networked resource monitoring tool that can help analyze resource trends and 'what just happened to kill our performance?' problems";
    homepage = http://munin-monitoring.org/;
    license = licenses.gpl2;
    maintainers = [ maintainers.iElectric ];
    platforms = platforms.linux;
  };
}
