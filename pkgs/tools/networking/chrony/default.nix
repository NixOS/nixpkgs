{ stdenv, fetchurl, libcap, readline }:

assert stdenv.isLinux -> libcap != null;

stdenv.mkDerivation rec {
  name = "chrony-1.27";
  
  src = fetchurl {
    url = "http://download.tuxfamily.org/chrony/${name}.tar.gz";
    sha256 = "17dfhcm5mrkg8ids0ajwscryr7fm7664kz10ygsa1ac047p3aj6l";
  };
  
  buildInputs = [ readline ] ++ stdenv.lib.optional stdenv.isLinux libcap;

  meta = with stdenv.lib; {
    description = "A pair of programs which are used to maintain the accuracy of the system clock on a computer.";
    homepage = "http://chrony.tuxfamily.org/";
    license = licenses.gpl2;
    platforms = platforms.unix;

    longDescription = ''
      Chronyd is a daemon which runs in background on the system. It obtains measurements via the network of the system clock’s offset relative to time servers on other systems and adjusts the system time accordingly. For isolated systems, the user can periodically enter the correct time by hand (using Chronyc). In either case, Chronyd determines the rate at which the computer gains or loses time, and compensates for this. Chronyd implements the NTP protocol and can act as either a client or a server.

      Chronyc provides a user interface to Chronyd for monitoring its performance and configuring various settings. It can do so while running on the same computer as the Chronyd instance it is controlling or a different computer.
    '';
  };
}
