{ lib
, stdenv
, fetchFromGitHub
, asio
, autoconf-archive
, autoreconfHook
, fetchpatch
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
, tinyxml-2
, wrapGAppsHook
}:

let
  openvpn3-core = fetchFromGitHub {
    owner = "OpenVPN";
    repo = "openvpn3";
    rev = "7765540e581c48721752bcad0b3d74b8397b1f73";
    sha256 = "sha256-v/suF/tWfuukQO1wFiHRzC7ZW+3Gh1tav6qj0uYUP4E=";
  };
in
stdenv.mkDerivation rec {
  pname = "openvpn3";
  # also update openvpn3-core
  version = "17_beta";

  src = fetchFromGitHub {
    owner = "OpenVPN";
    repo = "openvpn3-linux";
    rev = "v${version}";
    sha256 = "sha256-ITSnC105YNYFW1M2bOASFemPZAh+HETIzX2ofABWTho=";
  };

  patches = [
    # remove when v18_beta hits
    (fetchpatch {
      name = "dont-hardcode-gio.patch";
      url = "https://github.com/OpenVPN/openvpn3-linux/commit/f7d6d3ae1d52b18b398d3d3b6e21c720c98d0e89.patch";
      sha256 = "sha256-Bo5uaHadMTDROpwM7Y5aXhCoGUrsAAkSxeXLLhvOeEg=";
    })
  ];

  postPatch = ''
    rm -r ./vendor/googletest
    cp -r ${gtest.src} ./vendor/googletest
    rm -r ./openvpn3-core
    ln -s ${openvpn3-core} ./openvpn3-core

    chmod -R +w ./vendor/googletest
    shopt -s globstar

    patchShebangs **/*.py **/*.sh ./src/python/{openvpn2,openvpn3-as,openvpn3-autoload} \
    ./distro/systemd/openvpn3-systemd ./src/tests/dbus/netcfg-subscription-test

    echo "3.git:v${version}:unknown" > openvpn3-core-version
  '';

  preAutoreconf = ''
    substituteInPlace ./update-version-m4.sh --replace 'VERSION="$(git describe --always --tags)"' "VERSION=v${version}"
    ./update-version-m4.sh
  '';

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    python3.pkgs.docutils
    python3.pkgs.jinja2
    pkg-config
    wrapGAppsHook
    python3.pkgs.wrapPython
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
  ];

  # runtime deps
  pythonPath = with python3.pkgs; [
    dbus-python
    pygobject3
  ];

  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';
  postFixup = ''
    wrapPythonPrograms
  '';

  configureFlags = [
    "--enable-bash-completion"
    "--enable-addons-aws"
    "--disable-selinux-build"
    "--disable-build-test-progs"
  ];

  NIX_LDFLAGS = "-lpthread";

  meta = with lib; {
    description = "OpenVPN 3 Linux client";
    license = licenses.agpl3Plus;
    homepage = "https://github.com/OpenVPN/openvpn3-linux/";
    maintainers = with maintainers; [ shamilton kfears ];
    platforms = platforms.linux;
  };
}
