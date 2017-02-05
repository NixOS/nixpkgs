{ stdenv, lib, fetchFromGitHub
, autoreconfHook, docbook_xml_dtd_42, docbook_xsl, gettext, python3Packages
, intltool, libxslt, dbus, pkgconfig, iptables, ebtables, ipset, glib, kmod
, withKde ? true, plasma-nm ? null
}:

let
  slip = python3Packages.buildPythonPackage rec {
    name = "python-slip-${version}";
    version = "0.6.4";

    src = fetchFromGitHub {
      owner  = "nphilipp";
      repo   = "python-slip";
      rev    = name;
      sha256 = "07zyxy62738dzsvifm1241k0zx5l3xl6s5yfhyn88wc59fa8p570";
    };

    doCheck = false; # no tests

    buildPhase = ''
      runHook preBuild
      export PREFIX=$out
      make
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      make install
      runHook postInstall
    '';

  };

in python3Packages.buildPythonApplication rec {
  name = "firewalld-${version}";
  version = "0.4.4.4";

  src = fetchFromGitHub {
    owner  = "t-woerner";
    repo   = "firewalld";
    rev    = "v${version}";
    sha256 = "048flfcsi3ibp124k01hhf9bnbpyi3b92jgc96fhfvw6ns2l48qc";
  };

  doCheck = false; # no tests

  propagatedBuildInputs = with python3Packages; [
    dbus
    decorator
    pygobject3
    pyqt5
    six
    slip
  ];

  buildInputs = [
    autoreconfHook pkgconfig
    docbook_xml_dtd_42 docbook_xsl gettext intltool libxslt
    dbus ebtables glib ipset iptables
  ];

  preConfigure = ''
    patchShebangs .

    substituteInPlace doc/xml/*.xml \
      --replace "http://www.oasis-open.org/docbook/xml/4.2/docbookx.dtd" "${docbook_xml_dtd_42}/xml/dtd/docbook/docbookx.dtd"

    substituteInPlace src/firewall-applet \
      --replace /usr/bin/kde5-nm-connection-editor ${lib.getBin plasma-nm}/bin/kde5-nm-connection-editor

    export MODINFO=${kmod}/bin/modinfo
    export MODPROBE=${kmod}/bin/modprobe
    export RMMOD=${kmod}/bin/rmmod
  '';

  buildPhase = ''
    ./autogen.sh --prefix=$out
    make
  '';

  installPhase = ''
    make install $out
    cp -r config/{helpers,icmptypes,ipsets,services,zones} $out/etc/firewalld
  '';

  meta = with lib; {
    description = "A service daemon with D-Bus interface";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
