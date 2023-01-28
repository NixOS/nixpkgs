{ buildGoModule
, cmake
, fetchFromGitHub
, fetchpatch
, go
, lib
, pkg-config
, polkit
, python3
, qt5compat
, qtbase
, qtcharts
, qtnetworkauth
, qttools
, qtwebsockets
, rustPlatform
, stdenv
, which
, wireguard-tools
, wrapQtAppsHook
}:

let
  pname = "mozillavpn";
  version = "2.12.0";
  src = fetchFromGitHub {
    owner = "mozilla-mobile";
    repo = "mozilla-vpn-client";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-T8dPM90X4soVG/plKsf7DM9XgdX5Vcp0i6zTE60gbq0=";
  };
  patches = [
    # vpnglean: Add Cargo.lock file
    (fetchpatch {
      url = "https://github.com/mozilla-mobile/mozilla-vpn-client/pull/5236/commits/6fdc689001619a06b752fa629647642ea66f4e26.patch";
      hash = "sha256-j666Z31D29WIL3EXbek2aLzA4Fui/9VZvupubMDG24Q=";
    })
  ];

  netfilter-go-modules = (buildGoModule {
    inherit pname version src;
    modRoot = "linux/netfilter";
    vendorHash = "sha256-Cmo0wnl0z5r1paaEf1MhCPbInWeoMhGjnxCxGh0cyO8=";
  }).go-modules;

  extensionBridgeDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}-extension-bridge";
    preBuild = "cd extension/bridge";
    hash = "sha256-/DmKSV0IKxZV0Drh6dTsiqgZhuxt6CoegXpYdqN4UzQ=";
  };
  signatureDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}-signature";
    preBuild = "cd signature";
    hash = "sha256-6qyMARhPPgTryEtaBNrIPN9ja/fe7Fyx38iGuTd+Dk8=";
  };
  vpngleanDeps = rustPlatform.fetchCargoTarball {
    inherit src patches;
    name = "${pname}-${version}-vpnglean";
    preBuild = "cd vpnglean";
    hash = "sha256-8OLTQmRvy6pATEBX2za6f9vMEqwkf9L5VyERtAN2BDQ=";
  };

in
stdenv.mkDerivation {
  inherit pname version src patches;

  buildInputs = [
    polkit
    qt5compat
    qtbase
    qtcharts
    qtnetworkauth
    qtwebsockets
  ];
  nativeBuildInputs = [
    cmake
    go
    pkg-config
    python3
    python3.pkgs.glean-parser
    python3.pkgs.lxml
    python3.pkgs.pyyaml
    python3.pkgs.setuptools
    rustPlatform.cargoSetupHook
    rustPlatform.rust.cargo
    rustPlatform.rust.rustc
    which
    wrapQtAppsHook
  ];

  postUnpack = ''
    pushd source/extension/bridge
    cargoDeps='${extensionBridgeDeps}' cargoSetupPostUnpackHook
    extensionBridgeDepsCopy="$cargoDepsCopy"
    popd

    pushd source/signature
    cargoDeps='${signatureDeps}' cargoSetupPostUnpackHook
    signatureDepsCopy="$cargoDepsCopy"
    popd

    pushd source/vpnglean
    cargoDeps='${vpngleanDeps}' cargoSetupPostUnpackHook
    vpngleanDepsCopy="$cargoDepsCopy"
    popd
  '';
  dontCargoSetupPostUnpack = true;

  postPatch = ''
    for file in linux/*.service linux/extra/*.desktop src/platforms/linux/daemon/*.service; do
      substituteInPlace "$file" --replace /usr/bin/mozillavpn "$out/bin/mozillavpn"
    done

    substituteInPlace scripts/addon/build.py \
      --replace 'qtbinpath = args.qtpath' 'qtbinpath = "${qttools.dev}/bin"' \
      --replace 'rcc = os.path.join(qtbinpath, rcc_bin)' 'rcc = "${qtbase.dev}/libexec/rcc"'

    substituteInPlace src/cmake/linux.cmake \
      --replace '/etc/xdg/autostart' "$out/etc/xdg/autostart" \
      --replace '${"$"}{POLKIT_POLICY_DIR}' "$out/share/polkit-1/actions" \
      --replace '/usr/share/dbus-1' "$out/share/dbus-1" \
      --replace '${"$"}{SYSTEMD_UNIT_DIR}' "$out/lib/systemd/system"

    substituteInPlace extension/CMakeLists.txt \
      --replace '/etc' "$out/etc"

    ln -s '${netfilter-go-modules}' linux/netfilter/vendor

    pushd extension/bridge
    cargoDepsCopy="$extensionBridgeDepsCopy" cargoSetupPostPatchHook
    popd

    pushd signature
    cargoDepsCopy="$signatureDepsCopy" cargoSetupPostPatchHook
    popd

    pushd vpnglean
    cargoDepsCopy="$vpngleanDepsCopy" cargoSetupPostPatchHook
    popd

    cargoSetupPostPatchHook() { true; }
  '';

  cmakeFlags = [
    "-DQT_LCONVERT_EXECUTABLE=${qttools.dev}/bin/lconvert"
    "-DQT_LUPDATE_EXECUTABLE=${qttools.dev}/bin/lupdate"
    "-DQT_LRELEASE_EXECUTABLE=${qttools.dev}/bin/lrelease"
  ];
  dontFixCmake = true;

  qtWrapperArgs =
    [ "--prefix" "PATH" ":" (lib.makeBinPath [ wireguard-tools ]) ];

  meta = {
    description = "Client for the Mozilla VPN service";
    homepage = "https://vpn.mozilla.org/";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ andersk ];
    platforms = lib.platforms.linux;
  };
}
