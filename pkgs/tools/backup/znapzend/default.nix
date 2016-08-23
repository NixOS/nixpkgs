{ stdenv, fetchFromGitHub, zfs, mbuffer, perl, perlPackages, wget, autoconf, automake }:

let
  version = "0.15.7";
  checksum = "1xb94kxfq9sm3g0s6wpyyz6h2aihgca5gyybg0a5r8sar7yz97j0";
in
stdenv.mkDerivation rec {
  name = "znapzend-${version}";

  src = fetchFromGitHub {
    owner = "oetiker";
    repo = "znapzend";
    rev = "v${version}";
    sha256 = checksum;
  };

  buildInputs = [ perl perlPackages.TestHarness perlPackages.Mojolicious
                  perlPackages.TAPParserSourceHandlerpgTAP perlPackages.MojoIOLoopForkCall
                  perlPackages.IOPipely wget ];

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
      -I${perlPackages.TestHarness}/${perl.libPrefix} \
      -I${perlPackages.Mojolicious}/${perl.libPrefix} \
      -I${perlPackages.TAPParserSourceHandlerpgTAP}/${perl.libPrefix} \
      -I${perlPackages.MojoIOLoopForkCall}/${perl.libPrefix} \
      -I${perlPackages.IOPipely}/${perl.libPrefix} \
      "
    substituteInPlace $out/bin/znapzendzetup --replace "${perl}/bin/perl" \
      "${perl}/bin/perl \
      -I${perlPackages.TestHarness}/${perl.libPrefix} \
      -I${perlPackages.Mojolicious}/${perl.libPrefix} \
      -I${perlPackages.TAPParserSourceHandlerpgTAP}/${perl.libPrefix} \
      -I${perlPackages.MojoIOLoopForkCall}/${perl.libPrefix} \
      -I${perlPackages.IOPipely}/${perl.libPrefix} \
      "
    substituteInPlace $out/bin/znapzendztatz --replace "${perl}/bin/perl" \
      "${perl}/bin/perl \
      -I${perlPackages.TestHarness}/${perl.libPrefix} \
      -I${perlPackages.Mojolicious}/${perl.libPrefix} \
      -I${perlPackages.TAPParserSourceHandlerpgTAP}/${perl.libPrefix} \
      -I${perlPackages.MojoIOLoopForkCall}/${perl.libPrefix} \
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
