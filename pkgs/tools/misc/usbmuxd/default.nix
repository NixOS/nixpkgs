{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libusb1, libimobiledevice }:

stdenv.mkDerivation rec {
  pname = "usbmuxd";
  version = "2019-03-05";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = "b1b0bf390363fa36aff1bc09443ff751943b9c34";
    sha256 = "176hapckx98h4x0ni947qpkv2s95f8xfwz00wi2w7rgbr6cviwjq";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  propagatedBuildInputs = [ libimobiledevice libusb1 ];

  preConfigure = ''
    configureFlags="$configureFlags --with-udevrulesdir=$out/lib/udev/rules.d"
    configureFlags="$configureFlags --with-systemdsystemunitdir=$out/lib/systemd/system"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/libimobiledevice/usbmuxd;
    description = "A socket daemon to multiplex connections from and to iOS devices";
    longDescription = ''
      usbmuxd stands for "USB multiplexing daemon". This daemon is in charge of
      multiplexing connections over USB to an iOS device. To users, it means
      you can sync your music, contacts, photos, etc. over USB. To developers, it
      means you can connect to any listening localhost socket on the device. usbmuxd
      is not used for tethering data transfer which uses a dedicated USB interface as
      a virtual network device. Multiple connections to different TCP ports can happen
      in parallel. The higher-level layers are handled by libimobiledevice.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ infinisil ];
  };
}
