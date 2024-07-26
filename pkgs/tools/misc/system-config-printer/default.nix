{ lib, stdenv, fetchFromGitHub, udev, pkg-config, glib, xmlto, wrapGAppsHook
, docbook_xml_dtd_412, docbook_xsl
, libxml2, desktop-file-utils, libusb1, cups, gdk-pixbuf, pango, atk, libnotify
, gobject-introspection, libsecret, packagekit
, cups-filters, gettext, libtool, autoconf-archive
, python3Packages, autoreconfHook, bash, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "system-config-printer";
  version = "1.5.18";

  src = fetchFromGitHub {
    owner = "openPrinting";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-l3HEnYycP56vZWREWkAyHmcFgtu09dy4Ds65u7eqNZk=";
  };

  prePatch = ''
    # for automake
    touch README ChangeLog
    # for tests
    substituteInPlace Makefile.am --replace /bin/bash ${bash}/bin/bash
  '';

  patches = [
    ./detect_serverbindir.patch
    # fix typeerror, remove on next release
    (fetchpatch {
      url = "https://github.com/OpenPrinting/system-config-printer/commit/399b3334d6519639cfe7f1c0457e2475b8ee5230.patch";
      sha256 = "sha256-JCdGmZk2vRn3X1BDxOJaY3Aw8dr0ODVzi0oY20ZWfRs=";
      excludes = [ "NEWS" ];
    })
  ];

  buildInputs = [
    glib udev libusb1 cups
    python3Packages.python
    libnotify gdk-pixbuf pango atk packagekit
    libsecret
  ];

  nativeBuildInputs = [
    pkg-config gettext libtool autoconf-archive
    xmlto libxml2 docbook_xml_dtd_412 docbook_xsl desktop-file-utils
    python3Packages.wrapPython
    wrapGAppsHook autoreconfHook gobject-introspection
  ];

  pythonPath = with python3Packages; requiredPythonModules [ pycups pycurl dbus-python pygobject3 pycairo pysmbc ];

  configureFlags = [
    "--with-udev-rules"
    "--with-udevdir=${placeholder "out"}/etc/udev"
    "--with-systemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
  ];

  stripDebugList = [ "bin" "lib" "etc/udev" ];

  doCheck = true;

  postInstall =
    ''
      buildPythonPath "$out $pythonPath"
      gappsWrapperArgs+=(
        --prefix PATH : "$program_PATH"
        --set CUPS_DATADIR "${cups-filters}/share/cups"
      )

      find $out/share/system-config-printer -name \*.py -type f -perm -0100 -print0 | while read -d "" f; do
        patchPythonScript "$f"
      done
      patchPythonScript $out/etc/udev/udev-add-printer

      substituteInPlace $out/etc/udev/rules.d/70-printers.rules \
        --replace "udev-configure-printer" "$out/etc/udev/udev-configure-printer"
    '';

  meta = {
    homepage = "https://github.com/openprinting/system-config-printer";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2;
  };
}
