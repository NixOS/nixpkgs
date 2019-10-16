{ stdenv, fetchurl, substituteAll, intltool, pkgconfig, dbus, dbus-glib
, gnome3, systemd, libuuid, polkit, gnutls, ppp, dhcp, iptables, python3, vala
, libgcrypt, dnsmasq, bluez5, readline, libselinux, audit
, gobject-introspection, modemmanager, openresolv, libndp, newt, libsoup
, ethtool, gnused, iputils, kmod, jansson, gtk-doc, libxslt
, docbook_xsl, docbook_xml_dtd_412, docbook_xml_dtd_42, docbook_xml_dtd_43
, openconnect, curl, meson, ninja, libpsl }:

let
  pythonForDocs = python3.withPackages (pkgs: with pkgs; [ pygobject3 ]);
in stdenv.mkDerivation rec {
  pname = "network-manager";
  version = "1.18.4";

  src = fetchurl {
    url = "mirror://gnome/sources/NetworkManager/${stdenv.lib.versions.majorMinor version}/NetworkManager-${version}.tar.xz";
    sha256 = "0pnh1wr2p1fqa5pr945fr3lngfc5ccfrmgddqsg55lxnjpv0ggd3";
  };

  outputs = [ "out" "dev" "devdoc" "man" "doc" ];

  # Right now we hardcode quite a few paths at build time. Probably we should
  # patch networkmanager to allow passing these path in config file. This will
  # remove unneeded build-time dependencies.
  mesonFlags = [
    "-Ddhclient=${dhcp}/bin/dhclient"
    "-Ddnsmasq=${dnsmasq}/bin/dnsmasq"
    # Upstream prefers dhclient, so don't add dhcpcd to the closure
    "-Ddhcpcd=no"
    "-Ddhcpcanon=no"
    "-Dpppd=${ppp}/bin/pppd"
    "-Diptables=${iptables}/bin/iptables"
    # to enable link-local connections
    "-Dudev_dir=${placeholder "out"}/lib/udev"
    "-Dresolvconf=${openresolv}/bin/resolvconf"
    "-Ddbus_conf_dir=${placeholder "out"}/etc/dbus-1/system.d"
    "-Dsystemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
    "-Dkernel_firmware_dir=/run/current-system/firmware"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "-Dcrypto=gnutls"
    "-Dsession_tracking=systemd"
    "-Dmodem_manager=true"
    "-Dnmtui=true"
    "-Ddocs=true"
    # TODO: legacy library, will be *removed* in next release!
    "-Dlibnm_glib=true"
    "-Dtests=no"
    "-Dqt=false"
    # Allow using iwd when configured to do so
    "-Diwd=true"
    "-Dlibaudit=yes-disabled-by-default"
  ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit iputils kmod openconnect ethtool gnused dbus;
      inherit (stdenv) shell;
    })

    # Meson does not support using different directories during build and
    # for installation like Autotools did with flags passed to make install.
    ./fix-install-paths.patch
  ];

  buildInputs = [
    systemd libselinux audit libpsl libuuid polkit ppp libndp curl
    bluez5 dnsmasq gobject-introspection modemmanager readline newt libsoup jansson
  ];

  propagatedBuildInputs = [ dbus-glib gnutls libgcrypt ];

  nativeBuildInputs = [
    meson ninja intltool pkgconfig
    vala gobject-introspection
    dbus-glib # for dbus-binding-tool
    # Docs
    gtk-doc libxslt docbook_xsl docbook_xml_dtd_412 docbook_xml_dtd_42 docbook_xml_dtd_43 pythonForDocs
  ];

  doCheck = false; # requires /sys, the net


  postPatch = ''
    patchShebangs ./tools
    patchShebangs libnm/generate-setting-docs.py
  '';

  preBuild = ''
    # Our gobject-introspection patches make the shared library paths absolute
    # in the GIR files. When building docs, the library is not yet installed,
    # though, so we need to replace the absolute path with a local one during build.
    # We are using a symlink that will be overridden during installation.
    mkdir -p ${placeholder "out"}/lib
    ln -s $PWD/libnm/libnm.so.0 ${placeholder "out"}/lib/libnm.so.0
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "networkmanager";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/NetworkManager;
    description = "Network configuration and management tool";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ phreedom domenkozar obadz ];
    platforms = platforms.linux;
  };
}
