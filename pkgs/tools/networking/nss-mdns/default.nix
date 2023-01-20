{ fetchurl, lib, autoreconfHook, pkg-config, stdenv, fetchpatch, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "nss-mdns";
  version = "v0.15.1";

  src = fetchFromGitHub {
    owner = "lathiat";
    repo = pname;
    rev = version;
    hash = "sha256-iRaf9/gu9VkGi1VbGpxvC5q+0M8ivezCz/oAKEg5V1M=";
  };

  buildInputs = [ autoreconfHook pkg-config ];
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

    homepage = "http://0pointer.de/lennart/projects/nss-mdns/";
    license = lib.licenses.lgpl2Plus;

    # Supports both the GNU and FreeBSD NSS.
    platforms = lib.platforms.gnu ++ lib.platforms.linux ++ lib.platforms.freebsd;

    maintainers = [ ];
  };
}
