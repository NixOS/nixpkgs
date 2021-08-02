{ fetchurl, lib, stdenv, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "nss-mdns";
  version = "0.10";

  src = fetchurl {
    url = "http://0pointer.de/lennart/projects/nss-mdns/nss-mdns-${version}.tar.gz";
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

  patches = lib.optional stdenv.hostPlatform.isMusl
    (
      fetchpatch
      {
        url = "https://raw.githubusercontent.com/openembedded/openembedded-core/94f780e889f194b67a48587ac68b3200288bee10/meta/recipes-connectivity/libnss-mdns/libnss-mdns/0001-check-for-nss.h.patch";
        sha256 = "1l1kjbdw8z31br4vib3l5b85jy7kxin760a2f24lww8v6lqdpgds";
      }
    );


  meta = {
    description = "The mDNS Name Service Switch (NSS) plug-in";
    longDescription = ''
      `nss-mdns' is a plugin for the GNU Name Service Switch (NSS)
      functionality of the GNU C Library (glibc) providing host name
      resolution via Multicast DNS (mDNS), effectively allowing name
      resolution by common Unix/Linux programs in the ad-hoc mDNS
      domain `.local'.
    '';

    homepage = "http://0pointer.de/lennart/projects/nss-mdns/";
    license = lib.licenses.lgpl2Plus;

    # Supports both the GNU and FreeBSD NSS.
    platforms = lib.platforms.gnu ++ lib.platforms.linux ++ lib.platforms.freebsd;

    maintainers = [ ];
  };
}
