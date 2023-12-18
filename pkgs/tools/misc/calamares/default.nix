{ lib, fetchurl, boost, cmake, extra-cmake-modules, kparts, kpmcore, kirigami2
, kservice, libatasmart, libxcb, yaml-cpp, libpwquality, parted, polkit-qt, python
, qtbase, qtquickcontrols, qtsvg, qttools, qtwebengine, util-linux, tzdata
, ckbcomp, xkeyboard_config, mkDerivation
, nixos-extensions ? false
}:

mkDerivation rec {
  pname = "calamares";
  version = "3.2.62";

  # release including submodule
  src = fetchurl {
    url = "https://github.com/calamares/calamares/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-oPvOwqQ4aTdT/BdCIDVhGa1624orGcMXUYqhywJdbdA=";
  };

  patches = lib.optionals nixos-extensions [
    # Modifies the users module to only set passwords of user and root
    # as the users will have already been created in the configuration.nix file
    ./userjob.patch
    # Makes calamares search /run/current-system/sw/share/calamares/ for extra configuration files
    # as by default it only searches /usr/share/calamares/ and /nix/store/<hash>-calamares-<version>/share/calamares/
    # but calamares-nixos-extensions is not in either of these locations
    ./nixos-extensions-paths.patch
    # Uses pkexec within modules in order to run calamares without root permissions as a whole
    # Also fixes storage check in the welcome module
    ./nonroot.patch
    # Adds unfree qml to packagechooserq
    ./unfreeq.patch
    # Modifies finished module to add some NixOS resources
    # Modifies packagechooser module to change the UI
    ./uimod.patch
    # Remove options for unsupported partition types
    ./partitions.patch
    # Fix setting the kayboard layout on GNOME wayland
    # By default the module uses the setxkbmap, which will not change the keyboard
    ./waylandkbd.patch
    # Change default location where calamares searches for locales
    ./supportedlocale.patch
  ];

  nativeBuildInputs = [ cmake extra-cmake-modules ];
  buildInputs = [
    boost kparts.dev kpmcore.out kservice.dev kirigami2
    libatasmart libxcb yaml-cpp libpwquality parted polkit-qt python
    qtbase qtquickcontrols qtsvg qttools qtwebengine.dev util-linux
  ];

  cmakeFlags = [
    "-DPYTHON_LIBRARY=${python}/lib/lib${python.libPrefix}.so"
    "-DPYTHON_INCLUDE_DIR=${python}/include/${python.libPrefix}"
    "-DCMAKE_VERBOSE_MAKEFILE=True"
    "-DWITH_PYTHONQT:BOOL=ON"
  ];

  POLKITQT-1_POLICY_FILES_INSTALL_DIR = "$(out)/share/polkit-1/actions";

  postPatch = ''
    # Run calamares without root. Other patches make it functional as a normal user
    sed -e "s,pkexec calamares,calamares -D6," \
        -i calamares.desktop

    sed -e "s,X-AppStream-Ignore=true,&\nStartupWMClass=calamares," \
        -i calamares.desktop

    # Fix desktop reference with wayland
    mv calamares.desktop io.calamares.calamares.desktop

    sed -e "s,calamares.desktop,io.calamares.calamares.desktop," \
        -i CMakeLists.txt

    sed -e "s,/usr/bin/calamares,$out/bin/calamares," \
        -i com.github.calamares.calamares.policy

    sed -e 's,/usr/share/zoneinfo,${tzdata}/share/zoneinfo,' \
        -i src/modules/locale/SetTimezoneJob.cpp \
        -i src/libcalamares/locale/TimeZone.cpp

    sed -e 's,/usr/share/X11/xkb/rules/base.lst,${xkeyboard_config}/share/X11/xkb/rules/base.lst,' \
        -i src/modules/keyboard/keyboardwidget/keyboardglobal.cpp

    sed -e 's,"ckbcomp","${ckbcomp}/bin/ckbcomp",' \
        -i src/modules/keyboard/keyboardwidget/keyboardpreview.cpp

    sed "s,\''${POLKITQT-1_POLICY_FILES_INSTALL_DIR},''${out}/share/polkit-1/actions," \
        -i CMakeLists.txt
  '';

  meta = with lib; {
    description = "Distribution-independent installer framework";
    homepage = "https://calamares.io/";
    license = with licenses; [ gpl3Plus bsd2 cc0 ];
    maintainers = with maintainers; [ manveru vlinkz ];
    platforms = platforms.linux;
    mainProgram = "calamares";
  };
}
