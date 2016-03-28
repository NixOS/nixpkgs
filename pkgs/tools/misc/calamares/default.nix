{ stdenv, fetchurl, cmake, polkit-qt, libyamlcpp, python, boost, parted
, extra-cmake-modules, kconfig, ki18n, kcoreaddons, solid, utillinux, libatasmart
, ckbcomp, glibc, tzdata, xkeyboard_config, qtbase, qtquick1, qtsvg, qttools }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "calamares";
  version = "1.1.4.2";

  # release including submodule
  src = fetchurl {
    url = "https://github.com/${pname}/${pname}/releases/download/v${version}/${name}.tar.gz";
    sha256 = "1mh0nmzc3i1aqcj79q2s3vpccn0mirlfbj26sfyb0v6gcrvf707d";
  };

  buildInputs = [
    cmake qtbase qtquick1 qtsvg qttools libyamlcpp python boost polkit-qt parted
    extra-cmake-modules kconfig ki18n kcoreaddons solid utillinux libatasmart
  ];

  cmakeFlags = [
    "-DPYTHON_LIBRARY=${python}/lib/libpython${python.majorVersion}m.so"
    "-DPYTHON_INCLUDE_DIR=${python}/include/python${python.majorVersion}m"
    "-DWITH_PARTITIONMANAGER=1"
  ];

  patchPhase = ''
      sed -e "s,/usr/bin/calamares,$out/bin/calamares," \
          -i calamares.desktop \
          -i com.github.calamares.calamares.policy

      sed -e 's,/usr/share/zoneinfo,${tzdata}/share/zoneinfo,' \
          -i src/modules/locale/timezonewidget/localeconst.h \
          -i src/modules/locale/SetTimezoneJob.cpp

      sed -e 's,/usr/share/i18n/locales,${glibc}/share/i18n/locales,' \
          -i src/modules/locale/timezonewidget/localeconst.h

      sed -e 's,/usr/share/X11/xkb/rules/base.lst,${xkeyboard_config}/share/X11/xkb/rules/base.lst,' \
          -i src/modules/keyboard/keyboardwidget/keyboardglobal.h

      sed -e 's,"ckbcomp","${ckbcomp}/bin/ckbcomp",' \
          -i src/modules/keyboard/keyboardwidget/keyboardpreview.cpp
  '';

  preInstall = ''
    substituteInPlace cmake_install.cmake --replace "${polkit-qt}" "$out"
  '';

  meta = with stdenv.lib; {
    description = "Distribution-independent installer framework";
    license = licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
    platforms = platforms.linux;
    broken = true;
  };
}
