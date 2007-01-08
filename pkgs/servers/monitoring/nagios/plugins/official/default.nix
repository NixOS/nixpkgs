{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "nagios-plugins-1.4.5";

  src = fetchurl {
    url = http://kent.dl.sourceforge.net/sourceforge/nagiosplug/nagios-plugins-1.4.5.tar.gz;
    md5 = "359afddaf6a8e3228a5130b60bed0f67";
  };
}
