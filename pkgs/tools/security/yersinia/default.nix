{ stdenv, lib, fetchFromGitHub, autoreconfHook, pkg-config, fetchpatch
, ncurses, libpcap, libnet
# alpha version of GTK interface
, withGtk ? false, gtk2
# enable remote admin interface
, enableAdmin ? false
}:

stdenv.mkDerivation rec {
  pname = "yersinia";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "tomac";
    repo = pname;
    rev = "v${version}";
    sha256 = "06yfpf9iyi525rly1ychsihzvw3sas8kp0nxxr99xkwiqp5dc78b";
  };

  patches = [
    # ncurses-6.3 support, included in next release
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://github.com/tomac/yersinia/commit/d91bbf6f475e7ea39f131b77ce91b2de9646d5ca.patch";
      sha256 = "fl1pZKWA+nLtBm9+3FBFqaeuVZjszQCNkNl6Cf++BAI=";
    })

    # Pull upstream fix for -fno-common toolchain support:
    #   https://github.com/tomac/yersinia/pull/66
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/tomac/yersinia/commit/36247225dc7a6f38c4ba70537e20351f04762749.patch";
      sha256 = "KHaN8gfgNROEico27gWnYiP9ZVhpWz0KjFYy2t5tPBo=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libpcap libnet ncurses ]
    ++ lib.optional withGtk gtk2;

  autoreconfPhase = "./autogen.sh";

  configureFlags = [
    "--with-pcap-includes=${libpcap}/include"
    "--with-libnet-includes=${libnet}/include"
  ]
  ++ lib.optional (!enableAdmin) "--disable-admin"
  ++ lib.optional (!withGtk) "--disable-gtk";

  makeFlags = [ "LDFLAGS=-lncurses" ];

  meta = with lib; {
    description = "A framework for layer 2 attacks";
    homepage = "https://github.com/tomac/yersinia";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ vdot0x23 ];
    # INSTALL and FAQ in this package seem a little outdated
    # so not sure, but it could work on openbsd, illumos, and freebsd
    # if you have a machine to test with, feel free to add these
    platforms = with platforms; linux;
  };
}
