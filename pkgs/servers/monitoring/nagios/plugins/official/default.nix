{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "nagios-plugins-1.4.10";

  src = fetchurl {
    url = mirror://sourceforge/nagiosplug/nagios-plugins-1.4.10.tar.gz;
    sha256 = "0vm7sjiygxbfc5vbsi1g0dakpvynfzi86fhqx4yxd61brn0g8ghr";
  };

  meta = {
    description = "Official plugins for Nagios";
    homepage = http://www.nagios.org/;
    license = "GPL";
  };
}
