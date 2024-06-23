{ lib
, stdenv
, mkDerivation
, argp-standalone
, dbus
, dbus_cplusplus
, desktop-file-utils
, fetchurl
, fetchpatch
, glibmm
, libavc1394
, libconfig
, libiec61883
, libraw1394
, libxmlxx3
, pkg-config
, python3
, scons
, which
, wrapQtAppsHook
}:

let
  python = python3.withPackages (pkgs: with pkgs; [ pyqt5 dbus-python ]);
in
mkDerivation rec {
  pname = "ffado";
  version = "2.4.8";

  src = fetchurl {
    url = "http://www.ffado.org/files/libffado-${version}.tgz";
    hash = "sha256-0iFXYyGctOoHCdc232Ud80/wV81tiS7ItiS0uLKyq2Y=";
  };

  prePatch = ''
    substituteInPlace ./support/tools/ffado-diag.in \
      --replace /lib/modules/ "/run/booted-system/kernel-modules/lib/modules/"
  '';

  patches = [
    # fix installing metainfo file
    ./fix-build.patch

    (fetchpatch {
      name = "musl.patch";
      url = "http://subversion.ffado.org/changeset?format=diff&new=2846&old=2845";
      stripLen = 2;
      hash = "sha256-iWeYnb5J69Uvo1lftc7MWg7WrLa+CGZyOwJPOe8/PKg=";
    })
  ];

  outputs = [ "out" "bin" "dev" ];

  nativeBuildInputs = [
    desktop-file-utils
    scons
    pkg-config
    which
    python
    python3.pkgs.pyqt5
    wrapQtAppsHook
  ];

  prefixKey = "PREFIX=";
  sconsFlags = [
    "DEBUG=False"
    "ENABLE_ALL=True"
    "BUILD_TESTS=True"
    "WILL_DEAL_WITH_XDG_MYSELF=True"
    "BUILD_MIXER=True"
    "UDEVDIR=${placeholder "out"}/lib/udev/rules.d"
    "PYPKGDIR=${placeholder "out"}/${python3.sitePackages}"
    "BINDIR=${placeholder "bin"}/bin"
    "INCLUDEDIR=${placeholder "dev"}/include"
    "PYTHON_INTERPRETER=${python.interpreter}"
  ];

  buildInputs = [
    dbus
    dbus_cplusplus
    glibmm
    libavc1394
    libconfig
    libiec61883
    libraw1394
    libxmlxx3
    python
  ] ++ lib.optionals (!stdenv.hostPlatform.isGnu) [
    argp-standalone
  ];

  NIX_LDFLAGS = lib.optionalString (!stdenv.hostPlatform.isGnu) "-largp";

  enableParallelBuilding = true;
  dontWrapQtApps = true;

  postInstall = ''
    desktop="$bin/share/applications/ffado-mixer.desktop"
    install -DT -m 444 support/xdg/ffado.org-ffadomixer.desktop $desktop
    substituteInPlace "$desktop" \
      --replace Exec=ffado-mixer "Exec=$bin/bin/ffado-mixer" \
      --replace hi64-apps-ffado ffado-mixer
    install -DT -m 444 support/xdg/hi64-apps-ffado.png "$bin/share/icons/hicolor/64x64/apps/ffado-mixer.png"

    # prevent build tools from leaking into closure
    echo 'See `nix-store --query --tree ${placeholder "out"}`.' > $out/lib/libffado/static_info.txt
  '';

  preFixup = ''
    wrapQtApp $bin/bin/ffado-mixer
  '';

  meta = with lib; {
    homepage = "http://www.ffado.org";
    description = "FireWire audio drivers";
    license = licenses.gpl3;
    maintainers = with maintainers; [ goibhniu michojel ];
    platforms = platforms.linux;
  };
}
