{ stdenv, fetchFromGitHub, fetchurl, perl, perlPackages, wget, autoconf, automake }:

let
  # when upgrade znapzend, check versions of Perl libs here: https://github.com/oetiker/znapzend/blob/master/PERL_MODULES
  Mojolicious-6-46 = perlPackages.buildPerlPackage rec {
    name = "Mojolicious-6.46";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SR/SRI/${name}.tar.gz";
      sha256 = "0i3axmx4506fx5gms148pj65x6ys7flaz1aqjd8hd9zfkd8pzdfr";
    };
  };
  MojoIOLoopForkCall-0-17 = perlPackages.buildPerlModule rec {
    name = "Mojo-IOLoop-ForkCall-0.17";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JB/JBERGER/${name}.tar.gz";
      sha256 = "090qxz1nbah2qxvfg4whl6yp6q03qkx7a42751iai521nk1yavc8";
    };
    propagatedBuildInputs = [ perlPackages.IOPipely Mojolicious-6-46 ];
  };

  version = "0.18.0";
  checksum = "1nlvw56viwgafma506slywfg54z6009jmzc9q6wljgr6mqfmmchd";
in
stdenv.mkDerivation rec {
  name = "znapzend-${version}";

  src = fetchFromGitHub {
    owner = "oetiker";
    repo = "znapzend";
    rev = "v${version}";
    sha256 = checksum;
  };

  buildInputs = [ wget perl MojoIOLoopForkCall-0-17 perlPackages.TAPParserSourceHandlerpgTAP ];

  nativeBuildInputs = [ autoconf automake ];

  preConfigure = ''
    sed -i 's/^SUBDIRS =.*$/SUBDIRS = lib/' Makefile.am

    grep -v thirdparty/Makefile configure.ac > configure.ac.tmp
    mv configure.ac.tmp configure.ac

    autoconf
  '';

  preBuild = ''
    aclocal
    automake
  '';

  postInstall = ''
    substituteInPlace $out/bin/znapzend --replace "${perl}/bin/perl" \
      "${perl}/bin/perl \
      -I${Mojolicious-6-46}/${perl.libPrefix} \
      -I${perlPackages.TAPParserSourceHandlerpgTAP}/${perl.libPrefix} \
      -I${MojoIOLoopForkCall-0-17}/${perl.libPrefix} \
      -I${perlPackages.IOPipely}/${perl.libPrefix} \
      "
    substituteInPlace $out/bin/znapzendzetup --replace "${perl}/bin/perl" \
      "${perl}/bin/perl \
      -I${Mojolicious-6-46}/${perl.libPrefix} \
      -I${perlPackages.TAPParserSourceHandlerpgTAP}/${perl.libPrefix} \
      -I${MojoIOLoopForkCall-0-17}/${perl.libPrefix} \
      -I${perlPackages.IOPipely}/${perl.libPrefix} \
      "
    substituteInPlace $out/bin/znapzendztatz --replace "${perl}/bin/perl" \
      "${perl}/bin/perl \
      -I${Mojolicious-6-46}/${perl.libPrefix} \
      -I${perlPackages.TAPParserSourceHandlerpgTAP}/${perl.libPrefix} \
      -I${MojoIOLoopForkCall-0-17}/${perl.libPrefix} \
      -I${perlPackages.IOPipely}/${perl.libPrefix} \
      "
  '';

  meta = with stdenv.lib; {
    description = "High performance open source ZFS backup with mbuffer and ssh support";
    homepage    = http://www.znapzend.org;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ otwieracz ];
    platforms   = platforms.all;
  };
}
