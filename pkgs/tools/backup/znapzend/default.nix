{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  perl,
  perlPackages,
  wget,
  autoconf,
  automake,
  autoreconfHook,
}:

let
  # when upgrade znapzend, check versions of Perl libs here: https://github.com/oetiker/znapzend/blob/master/cpanfile
  # pinned versions are listed at https://github.com/oetiker/znapzend/blob/master/thirdparty/cpanfile-5.30.snapshot
  Mojolicious' = perlPackages.buildPerlPackage rec {
    pname = "Mojolicious";
    version = "8.73";
    src = fetchurl {
      url = "mirror://cpan/authors/id/S/SR/SRI/${pname}-${version}.tar.gz";
      sha256 = "118y2264f89bbp5ly2dh36xjq25jk85s2ssxa3y4gsgsk6sjzzk1";
    };
  };
  MojoIOLoopForkCall' = perlPackages.buildPerlModule rec {
    pname = "Mojo-IOLoop-ForkCall";
    version = "0.20";
    src = fetchurl {
      url = "mirror://cpan/authors/id/J/JB/JBERGER/${pname}-${version}.tar.gz";
      sha256 = "19pih5x0ayxs2m8j29qwdpi6ky3w4ghv6vrmax3ix9r59hj6569b";
    };
    propagatedBuildInputs = [
      perlPackages.IOPipely
      Mojolicious'
    ];
  };

  perl' = perl.withPackages (p: [
    MojoIOLoopForkCall'
    p.TAPParserSourceHandlerpgTAP
  ]);

  version = "0.21.0";
  sha256 = "1lg46rf2ahlclan29zx8ag5k4fjp28sc9l02z76f0pvdlj4qnihl";
in
stdenv.mkDerivation {
  pname = "znapzend";
  inherit version;

  src = fetchFromGitHub {
    owner = "oetiker";
    repo = "znapzend";
    rev = "v${version}";
    inherit sha256;
  };

  buildInputs = [
    wget
    perl'
  ];

  nativeBuildInputs = [
    autoconf
    automake
    autoreconfHook
  ];

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
    homepage = "https://www.znapzend.org";
    license = licenses.gpl3;
    maintainers = with maintainers; [ otwieracz ];
    platforms = platforms.all;
  };
}
