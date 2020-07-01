{ lib, mkDerivation, fetchurl, extra-cmake-modules, qtx11extras,
  plasma-workspace, libwacom, xf86_input_wacom
}:

mkDerivation rec {
  pname = "wacomtablet";
  version = "3.2.0";
  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/${pname}-${version}.tar.xz";
    sha256 = "197pwpl87gqlnza36bp68jvw8ww25znk08acmi8bpz7n84xfc368";
  };

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    qtx11extras plasma-workspace
    libwacom xf86_input_wacom
  ];

  meta = {
    description = "KDE Configuration Module for Wacom Graphics Tablets";
    longDescription = ''
      This module implements a GUI for the Wacom Linux Drivers and extends it
      with profile support to handle different button / pen layouts per profile.
    '';
    homepage = "https://cgit.kde.org/wacomtablet.git/about/";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.Thra11 ];
    platforms = lib.platforms.linux;
  };
}
