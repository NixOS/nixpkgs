{ lib, stdenv, fetchurl, pkg-config, libcap, readline, texinfo, nss, nspr
, libseccomp, pps-tools, gnutls }:

assert stdenv.isLinux -> libcap != null;

stdenv.mkDerivation rec {
  pname = "chrony";
  version = "4.2";

  src = fetchurl {
    url = "https://download.tuxfamily.org/chrony/${pname}-${version}.tar.gz";
    sha256 = "sha256-Jz+f0Vwyjtbzpfa6a67DWkIaNKc7tyVgUymxcSBI25o=";
  };

  postPatch = ''
    patchShebangs test
  '';

  buildInputs = [ readline texinfo nss nspr gnutls ]
    ++ lib.optionals stdenv.isLinux [ libcap libseccomp pps-tools ];
  nativeBuildInputs = [ pkg-config ];

  hardeningEnable = [ "pie" ];

  configureFlags = [ "--chronyvardir=$(out)/var/lib/chrony" "--enable-ntp-signd" ]
    ++ lib.optional stdenv.isLinux "--enable-scfilter";

  meta = with lib; {
    description = "Sets your computer's clock from time servers on the Net";
    homepage = "https://chrony.tuxfamily.org/";
    license = licenses.gpl2;
    platforms = with platforms; linux ++ freebsd ++ openbsd;
    maintainers = with maintainers; [ fpletz thoughtpolice ];

    longDescription = ''
      Chronyd is a daemon which runs in background on the system. It obtains
      measurements via the network of the system clock’s offset relative to
      time servers on other systems and adjusts the system time accordingly.
      For isolated systems, the user can periodically enter the correct time by
      hand (using Chronyc). In either case, Chronyd determines the rate at
      which the computer gains or loses time, and compensates for this. Chronyd
      implements the NTP protocol and can act as either a client or a server.

      Chronyc provides a user interface to Chronyd for monitoring its
      performance and configuring various settings. It can do so while running
      on the same computer as the Chronyd instance it is controlling or a
      different computer.
    '';
  };
}
