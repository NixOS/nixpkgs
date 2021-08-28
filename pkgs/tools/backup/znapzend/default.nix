{ lib, stdenv, fetchFromGitHub, fetchurl, perl, perlPackages, wget, autoconf, automake, autoreconfHook }:

let
  # when upgrade znapzend, check versions of Perl libs here: https://github.com/oetiker/znapzend/blob/master/cpanfile
  # pinned versions are listed at https://github.com/oetiker/znapzend/blob/master/thirdparty/cpanfile-5.26.1.snapshot
  Mojolicious-8-35 = perlPackages.buildPerlPackage rec {
    pname = "Mojolicious";
    version = "8.35";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SR/SRI/${pname}-${version}.tar.gz";
      sha256 = "1bll0ahh5v1y3x0ql29klwsa68cj46wzqc385srsnn2m8kh2ak8h";
    };
  };
  MojoIOLoopForkCall-0-20 = perlPackages.buildPerlModule rec {
    pname = "Mojo-IOLoop-ForkCall";
    version = "0.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JB/JBERGER/${pname}-${version}.tar.gz";
      sha256 = "19pih5x0ayxs2m8j29qwdpi6ky3w4ghv6vrmax3ix9r59hj6569b";
    };
    propagatedBuildInputs = [ perlPackages.IOPipely Mojolicious-8-35 ];
  };

  perl' = perl.withPackages (p:
    [ MojoIOLoopForkCall-0-20
      p.TAPParserSourceHandlerpgTAP
    ]);

  version = "0.20.0";
  checksum = "15lb5qwksa508m9bj6d3n4rrjpakfaas9qxspg408bcqfp7pqjw3";
in
stdenv.mkDerivation {
  pname = "znapzend";
  inherit version;

  src = fetchFromGitHub {
    owner = "oetiker";
    repo = "znapzend";
    rev = "v${version}";
    sha256 = checksum;
  };

  buildInputs = [ wget perl' ];

  nativeBuildInputs = [ autoconf automake autoreconfHook ];

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

  meta = with lib; {
    description = "High performance open source ZFS backup with mbuffer and ssh support";
    homepage    = "http://www.znapzend.org";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ otwieracz ];
    platforms   = platforms.all;
  };
}
