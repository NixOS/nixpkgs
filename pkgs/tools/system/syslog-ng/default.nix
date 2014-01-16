{ stdenv, fetchurl, eventlog, pkgconfig, glib, python }:

stdenv.mkDerivation {
  name = "syslog-ng-3.5.3";

  src = fetchurl {
    url = "http://www.balabit.com/downloads/files?path=/syslog-ng/sources/3.5.3/source/syslog-ng_3.5.3.tar.gz";
    sha256 = "1l3424qn9bf9z742pqba8x3dj7g729asimmhlizv1rvjlaxa2jd3";
  };

  buildInputs = [ eventlog pkgconfig glib python ];
  configureFlags = "--enable-dynamic-linking";

  meta = {
    homepage = "http://www.balabit.com/network-security/syslog-ng/";
    description = "Next-generation syslogd with advanced networking and filtering capabilities";
    license = "GPLv2";
  };
}
