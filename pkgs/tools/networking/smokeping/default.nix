{ stdenv, fetchurl, fping, rrdtool, FCGI, CGI
, CGIFast, ConfigGrammar, DigestHMAC, NetTelnet
, NetOpenSSH, NetSNMP, LWP, IOTty, perl, NetDNS
, NetLDAP
}:

stdenv.mkDerivation rec {
  name = "smokeping-${version}";
  version = "2.6.11";
  src = fetchurl {
    url = "http://oss.oetiker.ch/smokeping/pub/smokeping-${version}.tar.gz";
    sha256 = "1p9hpa2zs33p7hzrds80kwrm5255s0869v3s3qmsyx2sx63c7czj";
  };
  propagatedBuildInputs = [
    rrdtool FCGI CGI CGIFast ConfigGrammar DigestHMAC NetTelnet NetOpenSSH
      NetSNMP LWP IOTty fping perl NetDNS NetLDAP ];
  postInstall = ''
    mv $out/htdocs/smokeping.fcgi.dist $out/htdocs/smokeping.fcgi
  '';
  meta = {
    description = "Network latency collector";
    homepage = http://oss.oetiker.ch/smokeping;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.all;
  };
}
