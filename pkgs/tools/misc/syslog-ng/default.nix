{stdenv, fetchurl, eventlog, pkgconfig, glib}:

stdenv.mkDerivation {
  name = "syslog-ng-3.1.2";

  src = fetchurl {
    url = "http://www.balabit.com/downloads/files?path=/syslog-ng/sources/3.1.2/source/syslog-ng_3.1.2.tar.gz";
    sha256 = "0a508l4j11336jn5kg65l70rf7xbpdxi2n477rvp5p48cc1adcg2";
  };

  buildInputs = [eventlog pkgconfig glib];
  configureFlags = "--enable-dynamic-linking";

  meta = {
    homepage = "http://www.balabit.com/network-security/syslog-ng/";
    description = "Next-generation syslogd with advanced networking and filtering capabilities.";
    license = "GPLv2";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
