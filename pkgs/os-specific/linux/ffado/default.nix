{
  lib,
  stdenv,
  argp-standalone,
  dbus,
  dbus_cplusplus,
  fetchurl,
  glibmm,
  libavc1394,
  libconfig,
  libiec61883,
  libraw1394,
  libxmlxx3,
  pkg-config,
  python311,
  scons,
  which,
  withMixer ? false,
  qt5,
}:

let
  python =
    if withMixer then
      python311.withPackages (
        pkgs: with pkgs; [
          pyqt5
          dbus-python
        ]
      )
    else
      python311;
in
stdenv.mkDerivation rec {
  pname = "ffado";
  version = "2.4.9";

  outputs = [
    "out"
    "bin"
    "dev"
  ];

  src = fetchurl {
    url = "http://www.ffado.org/files/libffado-${version}.tgz";
    hash = "sha256-xELFL60Ryv1VE7tOhGyFHxAchIT4karFRe0ZDo/U0Q8=";
  };

  prePatch = ''
    substituteInPlace ./support/tools/ffado-diag.in \
      --replace /lib/modules/ "/run/booted-system/kernel-modules/lib/modules/"
  '';

  nativeBuildInputs =
    [
      (scons.override {
        # SConstruct script depends on distutils removed in Python 3.12
        python3Packages = python311.pkgs;
      })
      pkg-config
      which
    ]
    ++ lib.optionals withMixer [
      python
      python.pkgs.pyqt5
      qt5.wrapQtAppsHook
    ];

  prefixKey = "PREFIX=";
  sconsFlags = [
    "DEBUG=False"
    "ENABLE_ALL=True"
    "BUILD_TESTS=True"
    "BUILD_MIXER=${if withMixer then "True" else "False"}"
    "UDEVDIR=${placeholder "out"}/lib/udev/rules.d"
    "PYPKGDIR=${placeholder "out"}/${python.sitePackages}"
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
    # prevent build tools from leaking into closure
    echo 'See `nix-store --query --tree ${placeholder "out"}`.' > $out/lib/libffado/static_info.txt
  '';

  preFixup = lib.optionalString withMixer ''
    wrapQtApp "$bin/bin/ffado-mixer"
  '';

  meta = with lib; {
    homepage = "http://www.ffado.org";
    description = "FireWire audio drivers";
    license = licenses.gpl3;
    maintainers = with maintainers; [
      michojel
    ];
    platforms = platforms.linux;
  };
}
