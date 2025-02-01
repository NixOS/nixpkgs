{ lib, fetchurl, boost, cmake, extra-cmake-modules, kparts, kpmcore, kirigami2
, kservice, libatasmart, libxcb, yaml-cpp, libpwquality, parted, polkit-qt, python
, qtbase, qtquickcontrols, qtsvg, qttools, qtwebengine, util-linux, tzdata
, ckbcomp, xkeyboard_config, mkDerivation
, nixos-extensions ? false
}:

mkDerivation rec {
  pname = "calamares";
  version = "3.3.12";

  # release including submodule
  src = fetchurl {
    url = "https://github.com/calamares/calamares/releases/download/v${version}/calamares-${version}.tar.gz";
    sha256 = "sha256-TelcQ0Mm8+5oNIDqvGqb4j7L4BIPme987IMWdLEvMKM=";
  };

  # On major changes, or when otherwise required, you *must* :
  # 1. reformat the patches,
  # 2. `git am path/to/00*.patch` them into a calamares worktree,
  # 3. rebase to the more recent calamares version,
  # 4. and export the patches again via
  #   `git -c format.signoff=false format-patch v${version} --no-numbered --zero-commit --no-signature`.
  patches = lib.optionals nixos-extensions [
    ./0001-Modifies-the-users-module-to-only-set-passwords-of-u.patch
    ./0002-Makes-calamares-search-run-current-system-sw-share-c.patch
    ./0003-Uses-pkexec-within-modules-in-order-to-run-calamares.patch
    ./0004-Adds-unfree-qml-to-packagechooserq.patch
    ./0005-Modifies-finished-module-to-add-some-NixOS-resources.patch
    ./0006-Remove-options-for-unsupported-partition-types.patch
    ./0007-Fix-setting-the-kayboard-layout-on-GNOME-wayland.patch
    ./0008-Change-default-location-where-calamares-searches-for.patch
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
