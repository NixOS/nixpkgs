{stdenv, fetchurl, eventlog, pkgconfig, glib}:

stdenv.mkDerivation rec {
  name = "syslog-ng-2.1.3";
  meta = {
    homepage = "http://www.balabit.com/network-security/syslog-ng/";
    description = "Next-generation syslogd with advanced networking and filtering capabilities.";
    license = "GPLv2";
  };
  src = fetchurl {
    url = "http://www.balabit.com/downloads/files/syslog-ng/sources/2.1/src/${name}.tar.gz";
    sha256 = "1m6djxhmihmg09a90gg6mp1ghgk2zm8rcp04shh458433rbzfjb0";
  };
  buildInputs = [eventlog pkgconfig glib];
  configureFlags = "--enable-dynamic-linking";
}
