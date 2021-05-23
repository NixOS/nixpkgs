{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, libevdev
, libudev
, libconfig
}:

stdenv.mkDerivation rec {
  pname = "logiops";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "PixlOne";
    repo = "logiops";
    rev = "v${version}";
    sha256 = "1wgv6m1kkxl0hppy8vmcj1237mr26ckfkaqznj1n6cy82vrgdznn";
  };

  patches = [ ./logiops-no-systemd-service.patch ];

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ libevdev libudev libconfig ];

  meta = with lib; {
    description = "An unofficial userspace driver for HID++ Logitech mice and keyboards";
    longDescription = ''
      Logiops is an unofficial userspace driver for HID++ Logitech mice and keyboards.

      It can configure features like: easy programmable buttons, DPI selection,
      Smartshift (hyperfast and click-to-click wheel mode), HiresScroll, gestures.

      It is meant to run as a service, see `services.logiops`.

      Currently only compatible with HID++ >2.0 devices.
    '';
    license = licenses.gpl3;
    homepage = "https://github.com/PixlOne/logiops";
    platforms = platforms.linux;
    maintainers = with maintainers; [ zeorin ];
  };
}
