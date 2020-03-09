{ lib, fetchurl, boost, cmake, extra-cmake-modules, kparts, kpmcore
, kservice, libatasmart, libxcb, libyamlcpp, parted, polkit-qt, python, qtbase
, qtquickcontrols, qtsvg, qttools, qtwebengine, utillinux, glibc, tzdata
, ckbcomp, xkeyboard_config, mkDerivation
}:

mkDerivation rec {
  pname = "calamares";
  version = "3.2.17.1";

  # release including submodule
  src = fetchurl {
    url = "https://github.com/${pname}/${pname}/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "156zpjyw8w4y23aa60mvg3d3mr0kzfq5jkl7ixgahq33zpc17ms8";
  };

  buildInputs = [
    boost cmake extra-cmake-modules kparts.dev kpmcore.out kservice.dev
    libatasmart libxcb libyamlcpp parted polkit-qt python qtbase
    qtquickcontrols qtsvg qttools qtwebengine.dev utillinux
  ];

  enableParallelBuilding = false;

  cmakeFlags = [
    "-DPYTHON_LIBRARY=${python}/lib/lib${python.libPrefix}.so"
    "-DPYTHON_INCLUDE_DIR=${python}/include/${python.libPrefix}"
    "-DCMAKE_VERBOSE_MAKEFILE=True"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DWITH_PYTHONQT:BOOL=ON"
  ];

  POLKITQT-1_POLICY_FILES_INSTALL_DIR = "$(out)/share/polkit-1/actions";

  patchPhase = ''
    sed -e "s,/usr/bin/calamares,$out/bin/calamares," \
        -i calamares.desktop \
        -i com.github.calamares.calamares.policy

    sed -e 's,/usr/share/zoneinfo,${tzdata}/share/zoneinfo,' \
        -i src/modules/locale/timezonewidget/localeconst.h \
        -i src/modules/locale/SetTimezoneJob.cpp

    sed -e 's,/usr/share/i18n/locales,${glibc.out}/share/i18n/locales,' \
        -i src/modules/locale/timezonewidget/localeconst.h

    sed -e 's,/usr/share/X11/xkb/rules/base.lst,${xkeyboard_config}/share/X11/xkb/rules/base.lst,' \
        -i src/modules/keyboard/keyboardwidget/keyboardglobal.h

    sed -e 's,"ckbcomp","${ckbcomp}/bin/ckbcomp",' \
        -i src/modules/keyboard/keyboardwidget/keyboardpreview.cpp

    sed "s,\''${POLKITQT-1_POLICY_FILES_INSTALL_DIR},''${out}/share/polkit-1/actions," \
        -i CMakeLists.txt
  '';

  meta = with lib; {
    description = "Distribution-independent installer framework";
    license = licenses.gpl3;
    maintainers = with lib.maintainers; [ manveru ];
    platforms = platforms.linux;
  };
}
