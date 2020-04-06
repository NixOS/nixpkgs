{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, curl
, libimobiledevice
, libirecovery
, libzip
, libusbmuxd
}:

stdenv.mkDerivation rec {
  pname = "idevicerestore";
  version = "2019-12-26";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = "8207daaa2ac3cb3a5107aae6aefee8ecbe39b6d4";
    sha256 = "1jz72bzk1fh12bs65pv06l85135hgfz1aqnbb084bvqcpj4gl40h";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
  ];

  buildInputs = [
    curl
    libimobiledevice
    libirecovery
    libzip
    libusbmuxd
    # Not listing other dependencies specified in
    # https://github.com/libimobiledevice/idevicerestore/blob/8a882038b2b1e022fbd19eaf8bea51006a373c06/README#L20
    # because they are inherited `libimobiledevice`.
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/libimobiledevice/idevicerestore;
    description = "Restore/upgrade firmware of iOS devices";
    longDescription = ''
      The idevicerestore tool allows to restore firmware files to iOS devices.

      It is a full reimplementation of all granular steps which are performed during
      restore of a firmware to a device.

      In general, upgrades and downgrades are possible, however subject to
      availability of SHSH blobs from Apple for signing the firmare files.

      To restore a device to some firmware, simply run the following:
      $ sudo idevicerestore -l

      This will download and restore a device to the latest firmware available.
    '';
    license = licenses.lgpl21Plus;
    # configure.ac suggests it should work for darwin and mingw as well but not tried yet
    platforms = platforms.linux;
    maintainers = with maintainers; [ nh2 ];
  };
}
