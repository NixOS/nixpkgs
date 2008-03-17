{ fetchurl, stdenv, avahi }:

stdenv.mkDerivation rec {
  name = "nss-mdns-0.10";
  src = fetchurl {
    url = "http://0pointer.de/lennart/projects/nss-mdns/${name}.tar.gz";
    sha256 = "0vgs6j0qsl0mwzh5a0m0bykr7x6bx79vnbyn0r3q289rghp3qs0y";
  };

  configureFlags = "--enable-avahi";

  # Note: Although `nss-mdns' works by talking to `avahi-daemon', it
  # doesn't depend on the Avahi libraries.  Instead, it contains
  # hand-written D-Bus code to talk to the Avahi daemon.

  buildInput = [ avahi ];

  patchPhase = ''
    substituteInPlace "src/Makefile.in"						\
      --replace 'AVAHI_SOCKET=\"$(localstatedir)/run/avahi-daemon/socket\"'	\
                'AVAHI_SOCKET=\"${avahi}/run/avahi-daemon/socket\"'
  '';

  meta = {
    description = ''`nss-mdns' is a plugin for the GNU Name Service Switch
                    (NSS) functionality of the GNU C Library (glibc) providing
		    host name resolution via Multicast DNS (mDNS), effectively
		    allowing name resolution by common Unix/Linux programs in
		    the ad-hoc mDNS domain `.local'.'';
    homepage = http://0pointer.de/lennart/projects/nss-mdns/;
    license = "LGPLv2+";
  };
}
