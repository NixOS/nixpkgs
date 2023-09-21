{ lib
, stdenv
, fetchurl
, substituteAll
, gettext
, pkg-config
, dbus
, gnome
, systemd
, libuuid
, polkit
, gnutls
, ppp
, dhcpcd
, iptables
, nftables
, python3
, vala
, libgcrypt
, dnsmasq
, bluez5
, readline
, libselinux
, audit
, gobject-introspection
, perl
, modemmanager
, openresolv
, libndp
, newt
, libsoup
, ethtool
, gnused
, iputils
, kmod
, jansson
, elfutils
, gtk-doc
, libxslt
, docbook_xsl
, docbook_xml_dtd_412
, docbook_xml_dtd_42
, docbook_xml_dtd_43
, openconnect
, curl
, meson
, mesonEmulatorHook
, ninja
, libpsl
, mobile-broadband-provider-info
, runtimeShell
, buildPackages
}:

let
  pythonForDocs = python3.pythonForBuild.withPackages (pkgs: with pkgs; [ pygobject3 ]);
in
stdenv.mkDerivation rec {
  pname = "networkmanager";
  version = "1.42.8";

  src = fetchurl {
    url = "mirror://gnome/sources/NetworkManager/${lib.versions.majorMinor version}/NetworkManager-${version}.tar.xz";
    sha256 = "sha256-AzfnWD0uxa3iui6MYl0vCe7M2h0ig27imqcpJdOZw1M=";
  };

  outputs = [ "out" "dev" "devdoc" "man" "doc" ];

  # Right now we hardcode quite a few paths at build time. Probably we should
  # patch networkmanager to allow passing these path in config file. This will
  # remove unneeded build-time dependencies.
  mesonFlags = [
    # System paths
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "-Dsystemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
    # to enable link-local connections
    "-Dudev_dir=${placeholder "out"}/lib/udev"
    "-Ddbus_conf_dir=${placeholder "out"}/share/dbus-1/system.d"
    "-Dkernel_firmware_dir=/run/current-system/firmware"

    # Platform
    "-Dsession_tracking=systemd"
    "-Dlibaudit=yes-disabled-by-default"
    "-Dpolkit_agent_helper_1=/run/wrappers/bin/polkit-agent-helper-1"

    # Features
    # Allow using iwd when configured to do so
    "-Diwd=true"
    "-Dpppd=${ppp}/bin/pppd"
    "-Diptables=${iptables}/bin/iptables"
    "-Dnft=${nftables}/bin/nft"
    "-Dmodem_manager=true"
    "-Dnmtui=true"
    "-Ddnsmasq=${dnsmasq}/bin/dnsmasq"
    "-Dqt=false"

    # Handlers
    "-Dresolvconf=${openresolv}/bin/resolvconf"

    # DHCP clients
    # ISC DHCP client has reached it's end of life, so stop using it
    "-Ddhclient=no"
    "-Ddhcpcd=${dhcpcd}/bin/dhcpcd"
    "-Ddhcpcanon=no"

    # Miscellaneous
    # almost cross-compiles, however fails with
    # ** (process:9234): WARNING **: Failed to load shared library '/nix/store/...-networkmanager-aarch64-unknown-linux-gnu-1.38.2/lib/libnm.so.0' referenced by the typelib: /nix/store/...-networkmanager-aarch64-unknown-linux-gnu-1.38.2/lib/libnm.so.0: cannot open shared object file: No such file or directory
    "-Ddocs=${lib.boolToString (stdenv.buildPlatform == stdenv.hostPlatform)}"
    # We don't use firewalld in NixOS
    "-Dfirewalld_zone=false"
    "-Dtests=no"
    "-Dcrypto=gnutls"
    "-Dmobile_broadband_provider_info_database=${mobile-broadband-provider-info}/share/mobile-broadband-provider-info/serviceproviders.xml"
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
    systemd
    libselinux
    audit
    libpsl
    libuuid
    polkit
    ppp
    libndp
    curl
    mobile-broadband-provider-info
    bluez5
    dnsmasq
    modemmanager
    readline
    newt
    libsoup
    jansson
    dbus # used to get directory paths with pkg-config during configuration
  ];

  propagatedBuildInputs = [ gnutls libgcrypt ];

  nativeBuildInputs = [
    meson
    ninja
    gettext
    pkg-config
    vala
    gobject-introspection
    perl
    elfutils # used to find jansson soname
    # Docs
    gtk-doc
    libxslt
    docbook_xsl
    docbook_xml_dtd_412
    docbook_xml_dtd_42
    docbook_xml_dtd_43
    pythonForDocs
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  doCheck = false; # requires /sys, the net

  postPatch = ''
    patchShebangs ./tools
    patchShebangs libnm/generate-setting-docs.py

    # TODO: submit upstream
    substituteInPlace meson.build \
      --replace "'vala', req" "'vala', native: false, req"
  '';

  preBuild = ''
    # Our gobject-introspection patches make the shared library paths absolute
    # in the GIR files. When building docs, the library is not yet installed,
    # though, so we need to replace the absolute path with a local one during build.
    # We are using a symlink that will be overridden during installation.
    mkdir -p ${placeholder "out"}/lib
    ln -s $PWD/src/libnm-client-impl/libnm.so.0 ${placeholder "out"}/lib/libnm.so.0
  '';

  postFixup = lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    cp -r ${buildPackages.networkmanager.devdoc} $devdoc
    cp -r ${buildPackages.networkmanager.man} $man
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "NetworkManager";
      attrPath = "networkmanager";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Projects/NetworkManager";
    description = "Network configuration and management tool";
    license = licenses.gpl2Plus;
    changelog = "https://gitlab.freedesktop.org/NetworkManager/NetworkManager/-/raw/${version}/NEWS";
    maintainers = teams.freedesktop.members ++ (with maintainers; [ domenkozar obadz amaxine ]);
    platforms = platforms.linux;
  };
}
