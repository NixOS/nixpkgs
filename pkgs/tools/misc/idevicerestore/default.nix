{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config
, curl
, libimobiledevice
, libirecovery
, libzip
, libusbmuxd
, IOKit
}:

stdenv.mkDerivation rec {
  pname = "idevicerestore";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = version;
    sha256 = "1w7ywp77xc6v4hifi3j9ywrj447vv7fkwg2w26w0lq95f3bkblqr";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
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
  ] ++ lib.optionals stdenv.isDarwin [ IOKit ];

  meta = with lib; {
    homepage = "https://github.com/libimobiledevice/idevicerestore";
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
    # configure.ac suggests it should work for mingw as well but not tried yet
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ nh2 ];
  };
}
