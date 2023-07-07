{ lib
, stdenv
, fetchFromGitHub
, asio
, autoconf-archive
, autoreconfHook
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
    rev = "7590cb109349809b948e8edaeecabdbfe24e4b17";
    hash = "sha256-S9D/FQa7HYj0FJnyb5dCrtgTH9Nf2nvtyp/VHiebq7I=";
  };
in
stdenv.mkDerivation rec {
  pname = "openvpn3";
  # also update openvpn3-core
  version = "20";

  src = fetchFromGitHub {
    owner = "OpenVPN";
    repo = "openvpn3-linux";
    rev = "v${version}";
    hash = "sha256-Weyb+rcx04mpDdcL7Qt4O+PvPf5MLPAP/Uy+8qoNXbQ=";
  };

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
