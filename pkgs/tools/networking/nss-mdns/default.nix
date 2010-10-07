{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "nss-mdns-0.10";

  src = fetchurl {
    url = "http://0pointer.de/lennart/projects/nss-mdns/${name}.tar.gz";
    sha256 = "0vgs6j0qsl0mwzh5a0m0bykr7x6bx79vnbyn0r3q289rghp3qs0y";
  };

  # Note: Although `nss-mdns' works by talking to `avahi-daemon', it
  # doesn't depend on the Avahi libraries.  Instead, it contains
  # hand-written D-Bus code to talk to the Avahi daemon.

  configureFlags =
    [ # Try to use the Avahi daemon before resolving on our own.
      "--enable-avahi"

      # Connect to the daemon at `/var/run/avahi-daemon/socket'.
      "--localstatedir=/var"
    ];

  meta = {
    description = "The mDNS Name Service Switch (NSS) plug-in";
    longDescription = ''
      `nss-mdns' is a plugin for the GNU Name Service Switch (NSS)
      functionality of the GNU C Library (glibc) providing host name
      resolution via Multicast DNS (mDNS), effectively allowing name
      resolution by common Unix/Linux programs in the ad-hoc mDNS
      domain `.local'.
    '';

    homepage = http://0pointer.de/lennart/projects/nss-mdns/;
    license = "LGPLv2+";

    # Supports both the GNU and FreeBSD NSS.
    platforms = stdenv.lib.platforms.gnu ++ stdenv.lib.platforms.freebsd;

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
