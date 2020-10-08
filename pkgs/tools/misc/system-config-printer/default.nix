{ stdenv, fetchFromGitHub, fetchpatch, udev, intltool, pkgconfig, glib, xmlto, wrapGAppsHook
, docbook_xml_dtd_412, docbook_xsl
, libxml2, desktop-file-utils, libusb1, cups, gdk-pixbuf, pango, atk, libnotify
, gobject-introspection, libsecret, packagekit
, cups-filters
, python3Packages, autoreconfHook, bash
}:

stdenv.mkDerivation rec {
  pname = "system-config-printer";
  version = "1.5.12";

  src = fetchFromGitHub {
    owner = "openPrinting";
    repo = pname;
    rev = version;
    sha256 = "1a812jsd9pb02jbz9bq16qj5j6k2kw44g7s1xdqqkg7061rd7mwf";
  };

  prePatch = ''
    # for automake
    touch README ChangeLog
    # for tests
    substituteInPlace Makefile.am --replace /bin/bash ${bash}/bin/bash
  '';

  patches = [
    ./detect_serverbindir.patch

    # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=958104
    # (Fixes will be included in next upstream release.)
    (fetchpatch {
      url = "https://github.com/OpenPrinting/system-config-printer/commit/cf9903466c1a2d18a701f3b5e8c7e03483e1244d.patch";
      sha256 = "03gpav618w50q90m2kdkgwclc7fv17m493fgjd633zfavb5kqr3n";
    })
    (fetchpatch {
      url = "https://github.com/OpenPrinting/system-config-printer/commit/b9289dfe105bdb502f183f0afe7a115ecae5f2af.patch";
      sha256 = "12w47hy3ly4phh8jcqxvdnd5sgbnbp8dnscjd7d5y2i43kxj7b23";
    })
  ];

  buildInputs = [
    glib udev libusb1 cups
    python3Packages.python
    libnotify gobject-introspection gdk-pixbuf pango atk packagekit
    libsecret
  ];

  nativeBuildInputs = [
    intltool pkgconfig
    xmlto libxml2 docbook_xml_dtd_412 docbook_xsl desktop-file-utils
    python3Packages.wrapPython
    wrapGAppsHook autoreconfHook
  ];

  pythonPath = with python3Packages; requiredPythonModules [ pycups pycurl dbus-python pygobject3 requests pycairo pysmbc ];

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
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
  };
}
