{ lib, stdenv, fetchurl, fetchpatch, fping, rrdtool, perlPackages, autoreconfHook, nixosTests }:

stdenv.mkDerivation rec {
  pname = "smokeping";
  version = "2.8.2";
  src = fetchurl {
    url = "https://oss.oetiker.ch/smokeping/pub/smokeping-${version}.tar.gz";
    sha256 = "sha256-KeYRGLRV4juWmtpfjiq0MtPi74fUr+LIbeSgPXGItuo=";
  };

  patches = [
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/smokeping/raw/4ebf1921706a5a29c758fdce2f59cc35652c944a/f/smokeping-2.8.2-no-3rd-party.patch";
      hash = "sha256-97rQ4m9HHl3lIpQyjZvu+gZSrNIB2pckxmopCQAQPp0=";
    })
  ];

  propagatedBuildInputs = [ rrdtool ] ++
    (with perlPackages; [ perl FCGI CGI CGIFast ConfigGrammar DigestHMAC NetTelnet
      NetOpenSSH NetSNMP LWP IOTty fping NetDNS perlldap ]);

  nativeBuildInputs = [ autoreconfHook ];

  postInstall = ''
    mv $out/htdocs/smokeping.fcgi.dist $out/htdocs/smokeping.fcgi
  '';

  passthru.tests.smokeping = nixosTests.smokeping;

  meta = {
    description = "Network latency collector";
    homepage = "https://oss.oetiker.ch/smokeping";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.erictapen ];
  };
}
