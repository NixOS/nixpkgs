{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, curl
, libimobiledevice
, libirecovery
, libzip
, libusbmuxd
}:

stdenv.mkDerivation rec {
  pname = "idevicerestore";
  version = "1.0.0+date=2022-05-22";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = "f80a876b3598de4eb551bafcb279947c527fae33";
    hash = "sha256-I9zZQcZFd0hfeEJM7jltJtVJ6V5C5rA/S8gINiCnJdY=";
  };

  postPatch = ''
    echo '${version}' > .tarball-version
  '';

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
  ];

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
    platforms = platforms.unix;
    maintainers = with maintainers; [ nh2 ];
  };
}
