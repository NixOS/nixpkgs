{ stdenv, fetchurl, pkgconfig, libcap, readline, texinfo, nss, nspr }:

assert stdenv.isLinux -> libcap != null;

stdenv.mkDerivation rec {
  name = "chrony-${version}";

  version = "2.3";

  src = fetchurl {
    url = "http://download.tuxfamily.org/chrony/${name}.tar.gz";
    sha256 = "1cncjapm98hv1nyrqlanjpz8k5ny6rp4vnf0gjl0zyqj619gpgsq";
  };

  buildInputs = [ readline texinfo nss nspr ] ++ stdenv.lib.optional stdenv.isLinux libcap;
  nativeBuildInputs = [ pkgconfig ];

  configureFlags = [
    "--chronyvardir=$(out)/var/lib/chrony"
  ];

  meta = with stdenv.lib; {
    description = "Sets your computer's clock from time servers on the Net";
    homepage = http://chrony.tuxfamily.org/;
    repository.git = git://git.tuxfamily.org/gitroot/chrony/chrony.git;
    license = licenses.gpl2;
    platforms = with platforms; linux ++ freebsd ++ openbsd;
    maintainers = with maintainers; [ rickynils fpletz ];

    longDescription = ''
      Chronyd is a daemon which runs in background on the system. It obtains measurements via the network of the system clock’s offset relative to time servers on other systems and adjusts the system time accordingly. For isolated systems, the user can periodically enter the correct time by hand (using Chronyc). In either case, Chronyd determines the rate at which the computer gains or loses time, and compensates for this. Chronyd implements the NTP protocol and can act as either a client or a server.

      Chronyc provides a user interface to Chronyd for monitoring its performance and configuring various settings. It can do so while running on the same computer as the Chronyd instance it is controlling or a different computer.
    '';
  };
}
