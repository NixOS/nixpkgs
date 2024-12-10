{
  lib,
  stdenv,
  fetchFromGitLab,
  mkDerivation,
  buildGoModule,
  wrapQtAppsHook,
  python3Packages,
  pkg-config,
  openvpn,
  cmake,
  qmake,
  which,
  iproute2,
  iptables,
  procps,
  qmltermwidget,
  qtbase,
  qtdeclarative,
  qtgraphicaleffects,
  qtinstaller,
  qtquickcontrols,
  qtquickcontrols2,
  qttools,
  CoreFoundation,
  Security,
  provider ? "riseup",
}:
let
  version = "0.21.11";

  src = fetchFromGitLab {
    domain = "0xacab.org";
    owner = "leap";
    repo = "bitmask-vpn";
    rev = version;
    sha256 = "sha256-mhmKG6Exxh64oeeeLezJYWEw61iIHLasHjLomd2L8P4=";
  };

  # bitmask-root is only used on GNU/Linux
  # and may one day be replaced by pkg/helper
  bitmask-root = mkDerivation {
    inherit src version;
    sourceRoot = "${src.name}/helpers";
    pname = "bitmask-root";
    nativeBuildInputs = [ python3Packages.wrapPython ];
    postPatch = ''
      substituteInPlace bitmask-root \
        --replace 'swhich("ip")' '"${iproute2}/bin/ip"' \
        --replace 'swhich("iptables")' '"${iptables}/bin/iptables"' \
        --replace 'swhich("ip6tables")' '"${iptables}/bin/ip6tables"' \
        --replace 'swhich("sysctl")' '"${procps}/bin/sysctl"' \
        --replace /usr/sbin/openvpn ${openvpn}/bin/openvpn
      substituteInPlace se.leap.bitmask.policy \
        --replace /usr/sbin/bitmask-root $out/bin/bitmask-root
    '';
    installPhase = ''
      runHook preInstall

      install -m 755 -D -t $out/bin bitmask-root
      install -m 444 -D -t $out/share/polkit-1/actions se.leap.bitmask.policy
      wrapPythonPrograms

      runHook postInstall
    '';
  };
in

buildGoModule rec {
  inherit src version;
  pname = "${provider}-vpn";
  vendorHash = null;

  postPatch =
    ''
      substituteInPlace pkg/pickle/helpers.go \
        --replace /usr/share $out/share

      # Using $PROVIDER is not working,
      # thus replacing directly into the vendor.conf
      substituteInPlace providers/vendor.conf \
        --replace "provider = riseup" "provider = ${provider}"

      substituteInPlace branding/templates/debian/app.desktop-template \
        --replace "Icon=icon" "Icon=${pname}"

      patchShebangs gui/build.sh
      wrapPythonProgramsIn branding/scripts
    ''
    + lib.optionalString stdenv.isLinux ''
      substituteInPlace pkg/helper/linux.go \
        --replace /usr/sbin/openvpn ${openvpn}/bin/openvpn
      substituteInPlace pkg/vpn/launcher_linux.go \
        --replace /usr/sbin/openvpn ${openvpn}/bin/openvpn \
        --replace /usr/sbin/bitmask-root ${bitmask-root}/bin/bitmask-root \
        --replace /usr/bin/lxpolkit /run/wrappers/bin/polkit-agent-helper-1 \
        --replace '"polkit-gnome-authentication-agent-1",' '"polkit-gnome-authentication-agent-1","polkitd",'
    '';

  nativeBuildInputs = [
    cmake
    pkg-config
    python3Packages.wrapPython
    qmake
    qtquickcontrols2
    qttools
    which
    wrapQtAppsHook
  ] ++ lib.optional (!stdenv.isLinux) qtinstaller;

  buildInputs =
    [
      qtbase
      qmltermwidget
      qtdeclarative
      qtgraphicaleffects
      qtquickcontrols
      qtquickcontrols2
    ]
    ++ lib.optionals stdenv.isDarwin [
      CoreFoundation
      Security
    ];
  # FIXME: building on Darwin currently fails
  # due to missing debug symbols for Qt,
  # this should be fixable once darwin.apple_sdk >= 10.13
  # See https://bugreports.qt.io/browse/QTBUG-76777

  # Not using buildGoModule's buildPhase:
  # gui/build.sh will build Go modules into lib/libgoshim.a
  buildPhase = ''
    runHook preBuild

    make gen_providers_json
    make generate
    # Remove timestamps in comments
    sed -i -e '/^\/\//d' pkg/config/version/version.go

    # Not using -j$NIX_BUILD_CORES because the Makefile's rules
    # are not thread-safe: lib/libgoshim.h is used before being built.
    make build

    runHook postBuild
  '';

  postInstall =
    ''
      install -m 755 -D -t $out/bin build/qt/release/${pname}

      VERSION=${version} VENDOR_PATH=providers branding/scripts/generate-debian branding/templates/debian/data.json
      (cd branding/templates/debian && ${python3Packages.python}/bin/python3 generate.py)
      install -m 444 -D branding/templates/debian/app.desktop $out/share/applications/${pname}.desktop
      install -m 444 -D providers/${provider}/assets/icon.svg $out/share/icons/hicolor/scalable/apps/${pname}.svg
    ''
    + lib.optionalString stdenv.isLinux ''
      install -m 444 -D -t $out/share/polkit-1/actions ${bitmask-root}/share/polkit-1/actions/se.leap.bitmask.policy
    '';

  # Some tests need access to the Internet:
  # Post "https://api.black.riseup.net/3/cert": dial tcp: lookup api.black.riseup.net on [::1]:53: read udp [::1]:56553->[::1]:53: read: connection refused
  doCheck = false;

  passthru = { inherit bitmask-root; };

  meta = {
    description = "Generic VPN client by LEAP";
    longDescription = ''
      Bitmask, by LEAP (LEAP Encryption Access Project),
      is an application to provide easy and secure encrypted communication
      with a VPN (Virtual Private Network). It allows you to select from
      a variety of trusted service provider all from one app.
      Current providers include Riseup Networks
      and The Calyx Institute, where the former is default.
      The <literal>${pname}</literal> executable should appear
      in your desktop manager's XDG menu or could be launch in a terminal
      to get an execution log. A new icon should then appear in your systray
      to control the VPN and configure some options.
    '';
    homepage = "https://bitmask.net";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ julm ];
    # darwin requires apple_sdk >= 10.13
    platforms = lib.platforms.linux;
  };
}
