{ lib, stdenv, fetchurl, substituteAll, intltool, pkg-config, fetchpatch, dbus
, gnome, systemd, libuuid, polkit, gnutls, ppp, dhcp, iptables, python3, vala
, libgcrypt, dnsmasq, bluez5, readline, libselinux, audit
, gobject-introspection, modemmanager, openresolv, libndp, newt, libsoup
, ethtool, gnused, iputils, kmod, jansson, gtk-doc, libxslt
, docbook_xsl, docbook_xml_dtd_412, docbook_xml_dtd_42, docbook_xml_dtd_43
, openconnect, curl, meson, ninja, libpsl, mobile-broadband-provider-info, runtimeShell }:

let
  pythonForDocs = python3.withPackages (pkgs: with pkgs; [ pygobject3 ]);
in stdenv.mkDerivation rec {
  pname = "networkmanager";
  version = "1.30.4";

  src = fetchurl {
    url = "mirror://gnome/sources/NetworkManager/${lib.versions.majorMinor version}/NetworkManager-${version}.tar.xz";
    sha256 = "sha256-YFC3JCEuo85zhhEzWb6pr6H2eaVPYNmZpZmYkuZywZA=";
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
    "-Ddbus_conf_dir=${placeholder "out"}/share/dbus-1/system.d"
    "-Dsystemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
    "-Dkernel_firmware_dir=/run/current-system/firmware"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "-Dcrypto=gnutls"
    "-Dsession_tracking=systemd"
    "-Dmodem_manager=true"
    "-Dnmtui=true"
    "-Ddocs=true"
    "-Dtests=no"
    "-Dqt=false"
    "-Dpolkit_agent_helper_1=/run/wrappers/bin/polkit-agent-helper-1"
    # Allow using iwd when configured to do so
    "-Diwd=true"
    "-Dlibaudit=yes-disabled-by-default"
    # We don't use firewalld in NixOS
    "-Dfirewalld_zone=false"
  ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit iputils kmod openconnect ethtool gnused systemd;
      inherit runtimeShell;
    })

    # Meson does not support using different directories during build and
    # for installation like Autotools did with flags passed to make install.
    ./fix-install-paths.patch
  ];

  buildInputs = [
    systemd libselinux audit libpsl libuuid polkit ppp libndp curl mobile-broadband-provider-info
    bluez5 dnsmasq gobject-introspection modemmanager readline newt libsoup jansson
  ];

  propagatedBuildInputs = [ gnutls libgcrypt ];

  nativeBuildInputs = [
    meson ninja intltool pkg-config
    vala gobject-introspection dbus
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
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "networkmanager";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Projects/NetworkManager";
    description = "Network configuration and management tool";
    license = licenses.gpl2Plus;
    maintainers = teams.freedesktop.members ++ (with maintainers; [ phreedom domenkozar obadz ]);
    platforms = platforms.linux;
  };
}
