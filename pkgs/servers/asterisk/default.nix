{ stdenv, pkgs, fetchurl, fetchgit,
  jansson, libxml2, libxslt, ncurses, openssl, sqlite,
  utillinux, dmidecode, libuuid, binutils, newt,
  lua,
  srtp, wget, curl,
  subversionClient
}:
stdenv.mkDerivation rec {
  name = "asterisk-${version}";
  version = "14.1.2";

  src = fetchurl {
    url = "http://downloads.asterisk.org/pub/telephony/asterisk/old-releases/asterisk-${version}.tar.gz";
    sha256 = "0w9s4334rwvpyxm169grmnb4k9yq0l2al73dyh4cb8769qcs0ij8";
  };

  # Note that these sounds are included with the release tarball. They are
  # provided here verbatim for the convenience of anyone wanting to build
  # Asterisk from other sources.
  coreSounds = fetchurl {
    url = http://downloads.asterisk.org/pub/telephony/sounds/releases/asterisk-core-sounds-en-gsm-1.5.tar.gz;
    sha256 = "01xzbg7xy0c5zg7sixjw5025pvr4z64kfzi9zvx19im0w331h4cd";
  };
  mohSounds = fetchurl {
    url = http://downloads.asterisk.org/pub/telephony/sounds/releases/asterisk-moh-opsound-wav-2.03.tar.gz;
    sha256 = "449fb810d16502c3052fedf02f7e77b36206ac5a145f3dacf4177843a2fcb538";
  };
  # TODO: Sounds for other languages could be added here

  buildInputs = [ jansson libxml2 libxslt ncurses openssl sqlite utillinux dmidecode libuuid binutils newt lua srtp wget curl subversionClient ];

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
  # preConfigure = ''
  #   ln -s ${coreSounds} sounds/asterisk-core-sounds-en-gsm-1.5.tar.gz
  #   ln -s ${mohSounds} sounds/asterisk-moh-opsound-wav-2.03.tar.gz
  #'';

  # The default libdir is $PREFIX/usr/lib, which causes problems when paths
  # compiled into Asterisk expect ${out}/usr/lib rather than ${out}/lib.
  configureFlags = [
    "--libdir=\${out}/lib"
    "--with-lua=${lua}/lib"
    "--with-pjproject-bundled"
  ];

  preBuild = ''
    make menuselect.makeopts
    substituteInPlace menuselect.makeopts --replace 'format_mp3 ' ""
    ./contrib/scripts/get_mp3_source.sh
  '';

  postInstall = ''
    # Install sample configuration files for this version of Asterisk
    make samples
  '';

  meta = with stdenv.lib; {
    description = "Software implementation of a telephone private branch exchange (PBX)";
    homepage = http://www.asterisk.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ auntie DerTim1 ];
  };
}
