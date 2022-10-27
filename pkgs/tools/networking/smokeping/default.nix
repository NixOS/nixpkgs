{ lib, stdenv, fetchurl, fping, rrdtool, perlPackages, nixosTests }:

stdenv.mkDerivation rec {
  pname = "smokeping";
  version = "2.6.11";
  src = fetchurl {
    url = "https://oss.oetiker.ch/smokeping/pub/smokeping-${version}.tar.gz";
    sha256 = "1p9hpa2zs33p7hzrds80kwrm5255s0869v3s3qmsyx2sx63c7czj";
  };
  propagatedBuildInputs = [ rrdtool ] ++
    (with perlPackages; [ perl FCGI CGI CGIFast ConfigGrammar DigestHMAC NetTelnet
      NetOpenSSH NetSNMP LWP IOTty fping NetDNS perlldap ]);

  postInstall = ''
    mv $out/htdocs/smokeping.fcgi.dist $out/htdocs/smokeping.fcgi
  '';

  passthru.tests.smokeping = nixosTests.smokeping;

  meta = {
    description = "Network latency collector";
    homepage = "http://oss.oetiker.ch/smokeping";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.erictapen ];
  };
}
