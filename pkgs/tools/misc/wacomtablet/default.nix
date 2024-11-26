{ lib, mkDerivation, fetchurl, fetchpatch, extra-cmake-modules, qtx11extras,
  plasma-workspace, libwacom, xf86_input_wacom
}:

mkDerivation rec {
  pname = "wacomtablet";
  version = "3.2.0";
  src = fetchurl {
    url = "mirror://kde/stable/wacomtablet/${version}/wacomtablet-${version}.tar.xz";
    sha256 = "197pwpl87gqlnza36bp68jvw8ww25znk08acmi8bpz7n84xfc368";
  };
  patches = [
    (fetchpatch {
      url = "https://invent.kde.org/system/wacomtablet/commit/4f73ff02b3efd5e8728b18fcf1067eca166704ee.patch";
      sha256 = "0185gbh1vywfz8a3wnvncmzdk0dd189my4bzimkbh85rlrqq2nf8";
    })
  ];

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    qtx11extras plasma-workspace
    libwacom xf86_input_wacom
  ];

  meta = {
    description = "KDE Configuration Module for Wacom Graphics Tablets";
    mainProgram = "kde_wacom_tabletfinder";
    longDescription = ''
      This module implements a GUI for the Wacom Linux Drivers and extends it
      with profile support to handle different button / pen layouts per profile.
    '';
    homepage = "https://invent.kde.org/system/wacomtablet";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.Thra11 ];
    platforms = lib.platforms.linux;
  };
}
