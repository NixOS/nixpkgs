{ lib
, stdenv
, fetchFromGitHub
, asio
, glib
, gtest
, jsoncpp
, libcap_ng
, libnl
, libuuid
, lz4
, openssl
, pkg-config
, protobuf
, python3
, systemd
, enableSystemdResolved ? false
, tinyxml-2
, meson
, cmake
, dbus
, callPackage
, fetchurl
, unzip
, ninja
, writeShellScript
, libcxx
}:
let
  gdbuspp = callPackage ./gdbuspp.nix {};

  gtest-wrap = stdenv.mkDerivation {
    name = "gtest-wrap";
    src = fetchurl {
      url = "https://wrapdb.mesonbuild.com/v1/projects/gtest/1.10.0/1/get_zip";
      name = "gtest-1.10.0-1-wrap.zip";
      hash = "sha256-BP8U6IgOTkZfYmAiHp39Vv6mvHzOTEr/DcUo5KLI9RQ=";
    };
    nativeBuildInputs = [ unzip ];
    installPhase = ''
      mkdir $out
      cp -rv . $out
    '';
  };

  version = "23";

  src = fetchFromGitHub {
    owner = "OpenVPN";
    repo = "openvpn3-linux";
    rev = "v${version}";
    hash = "sha256-5gkutqyUPZDwRPzSFdUXg2G5mtQKbdhZu8xnNAdXoF0=";
    fetchSubmodules = true;
  };

  openvpn3-core-version = writeShellScript "version" ''
    MAJOR="3"
    echo "$MAJOR.git:${src.rev}"
  '';
in
stdenv.mkDerivation rec {
  pname = "openvpn3";

  inherit src version;

  prePatch = ''
    cp -r ${gtest.src} ./subprojects/googletest-release-1.10.0
    chmod -R +w ./subprojects/googletest-release-1.10.0
    cp -r ${gtest-wrap}/* ./subprojects/googletest-release-1.10.0

    patchShebangs ./scripts/* ./openvpn3-core/scripts/*
    substituteInPlace ./scripts/get-version --replace 'VERSION="$(git describe --always --tags)"' "VERSION=v${version}"
    cp "${openvpn3-core-version}" ./openvpn3-core/scripts/version

    # to trigger the creation of host-version.h, which is required at build time
    mkdir .git

    sed -i '1i#include <iomanip>' src/tests/unit/machine-id.cpp
    substituteInPlace ./meson.build \
      --replace "dbus_policy_dir = dep_dbus.get_variable('datadir') / 'dbus-1' / 'system.d'" "dbus_policy_dir = '$out/dbus-1/system.d'" \
      --replace "dbus_service_dir = dep_dbus.get_variable('system_bus_services_dir')" "dbus_service_dir = '$out/etc/dbus-1/system-services'"
  '';

  nativeBuildInputs = [
    python3.pkgs.docutils
    pkg-config
    meson
    cmake
    ninja
  ] ++ pythonPath;

  buildInputs = [
    asio
    glib
    jsoncpp
    libcap_ng
    libnl
    libuuid
    lz4
    openssl
    protobuf
    tinyxml-2
    dbus
    gdbuspp
    libcxx
  ] ++ lib.optionals enableSystemdResolved [
    systemd
  ];

  # runtime deps
  pythonPath = with python3.pkgs; [
    dbus-python
    pygobject3
  ];

  mesonFlags = [
    (lib.mesonOption "selinux" "disabled")
    (lib.mesonOption "selinux_policy" "disabled")
    (lib.mesonOption "test_programs" "disabled")
    (lib.mesonOption "openvpn3_statedir" "${placeholder "out"}/share/openvpn3")
  ];

  meta = with lib; {
    description = "OpenVPN 3 Linux client";
    license = licenses.agpl3Plus;
    homepage = "https://github.com/OpenVPN/openvpn3-linux/";
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
