{ lib, fetchurl, boost, cmake, extra-cmake-modules, kparts, kpmcore
, kservice, libatasmart, libxcb, libyamlcpp, parted, polkit-qt, python, qtbase
, qtquickcontrols, qtsvg, qttools, qtwebengine, util-linux, tzdata
, ckbcomp, xkeyboard_config, mkDerivation
}:

mkDerivation rec {
  pname = "calamares";
  version = "3.2.53";

  # release including submodule
  src = fetchurl {
    url = "https://github.com/${pname}/${pname}/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-LWkgQsvP7XmupBDSAnbwewWRT+ZaALyDFw3w7iz66X0=";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules ];
  buildInputs = [
    boost kparts.dev kpmcore.out kservice.dev
    libatasmart libxcb libyamlcpp parted polkit-qt python qtbase
    qtquickcontrols qtsvg qttools qtwebengine.dev util-linux
  ];

  cmakeFlags = [
    "-DPYTHON_LIBRARY=${python}/lib/lib${python.libPrefix}.so"
    "-DPYTHON_INCLUDE_DIR=${python}/include/${python.libPrefix}"
    "-DCMAKE_VERBOSE_MAKEFILE=True"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DWITH_PYTHONQT:BOOL=ON"
  ];

  POLKITQT-1_POLICY_FILES_INSTALL_DIR = "$(out)/share/polkit-1/actions";

  postPatch = ''
    sed -e "s,/usr/bin/calamares,$out/bin/calamares," \
        -i calamares.desktop \
        -i com.github.calamares.calamares.policy

    sed -e 's,/usr/share/zoneinfo,${tzdata}/share/zoneinfo,' \
        -i src/modules/locale/SetTimezoneJob.cpp

    sed -e 's,/usr/share/X11/xkb/rules/base.lst,${xkeyboard_config}/share/X11/xkb/rules/base.lst,' \
        -i src/modules/keyboard/keyboardwidget/keyboardglobal.h

    sed -e 's,"ckbcomp","${ckbcomp}/bin/ckbcomp",' \
        -i src/modules/keyboard/keyboardwidget/keyboardpreview.cpp

    sed "s,\''${POLKITQT-1_POLICY_FILES_INSTALL_DIR},''${out}/share/polkit-1/actions," \
        -i CMakeLists.txt
  '';

  meta = with lib; {
    description = "Distribution-independent installer framework";
    license = with licenses; [ gpl3Plus bsd2 ];
    maintainers = with maintainers; [ manveru ];
    platforms = platforms.linux;
  };
}
