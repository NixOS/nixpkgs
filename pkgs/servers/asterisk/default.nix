{ stdenv, fetchurl, fetchgit, jansson, libxml2, libxslt, ncurses, openssl, sqlite, utillinux }:

stdenv.mkDerivation rec {
  name = "asterisk-${version}";
  version = "13.6.0";

  src = fetchurl {
    url = "http://downloads.asterisk.org/pub/telephony/asterisk/old-releases/asterisk-${version}.tar.gz";
    sha256 = "0nh0fnqx84as92kk9d73s0386cndd17l06y1c72jl2bdjhyba0ca";
  };

  # Note that these sounds are included with the release tarball. They are
  # provided here verbatim for the convenience of anyone wanting to build
  # Asterisk from other sources.
  coreSounds = fetchurl {
    url = http://downloads.asterisk.org/pub/telephony/sounds/releases/asterisk-core-sounds-en-gsm-1.4.26.tar.gz;
    sha256 = "2300e3ed1d2ded6808a30a6ba71191e7784710613a5431afebbd0162eb4d5d73";
  };
  mohSounds = fetchurl {
    url = http://downloads.asterisk.org/pub/telephony/sounds/releases/asterisk-moh-opsound-wav-2.03.tar.gz;
    sha256 = "449fb810d16502c3052fedf02f7e77b36206ac5a145f3dacf4177843a2fcb538";
  };
  # TODO: Sounds for other languages could be added here

  buildInputs = [ jansson libxml2 libxslt ncurses openssl sqlite utillinux ];

  patches = [
    # Disable downloading of sound files (we will fetch them
    # ourselves if needed).
    ./disable-download.patch

    # We want the Makefile to install the default /var skeleton
    # under ${out}/var but we also want to use /var at runtime.
    # This patch changes the runtime behavior to look for state
    # directories in /var rather than ${out}/var.
    ./runtime-vardirs.patch
  ];

  # Use the following preConfigure section when building Asterisk from sources
  # other than the release tarball.
#   preConfigure = ''
#     ln -s ${coreSounds} sounds/asterisk-core-sounds-en-gsm-1.4.26.tar.gz
#     ln -s ${mohSounds} sounds/asterisk-moh-opsound-wav-2.03.tar.gz
#   '';

  # The default libdir is $PREFIX/usr/lib, which causes problems when paths
  # compiled into Asterisk expect ${out}/usr/lib rather than ${out}/lib.
  configureFlags = "--libdir=\${out}/lib";

  postInstall = ''
    # Install sample configuration files for this version of Asterisk
    make samples
  '';

  meta = with stdenv.lib; {
    description = "Software implementation of a telephone private branch exchange (PBX)";
    homepage = http://www.asterisk.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ auntie ];
    # Marked as broken due to needing an update for security issues.
    # See: https://github.com/NixOS/nixpkgs/issues/18856
    broken = true;
  };
}
