{ buildGoModule
, cargo
, cmake
, fetchFromGitHub
, go
, lib
, libcap
, libgcrypt
, libgpg-error
, libsecret
, pkg-config
, polkit
, python3
, qt5compat
, qtbase
, qtnetworkauth
, qtsvg
, qttools
, qtwebsockets
, rustPlatform
, rustc
, stdenv
, wireguard-tools
, wrapQtAppsHook
}:

let
  pname = "mozillavpn";
  version = "2.17.1";
  src = fetchFromGitHub {
    owner = "mozilla-mobile";
    repo = "mozilla-vpn-client";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-sxkah+tVCbw62A57ia0JnOgmdqojL7inoSStilEhoMg=";
  };
  patches = [ ];

  netfilterGoModules = (buildGoModule {
    inherit pname version src patches;
    modRoot = "linux/netfilter";
    vendorHash = "sha256-Cmo0wnl0z5r1paaEf1MhCPbInWeoMhGjnxCxGh0cyO8=";
  }).goModules;

  extensionBridgeDeps = rustPlatform.fetchCargoTarball {
    inherit src patches;
    name = "${pname}-${version}-extension-bridge";
    preBuild = "cd extension/bridge";
    hash = "sha256-3sncaaeUdCQd8yZHu9z54BaXEvNOqn7sqsUREIOIxDY=";
  };
  signatureDeps = rustPlatform.fetchCargoTarball {
    inherit src patches;
    name = "${pname}-${version}-signature";
    preBuild = "cd signature";
    hash = "sha256-E/DutZai+Jq/5pq5wQ4haZUkb4Roq2Loh0epZNGxOtw=";
  };
  qtgleanDeps = rustPlatform.fetchCargoTarball {
    inherit src patches;
    name = "${pname}-${version}-qtglean";
    preBuild = "cd qtglean";
    hash = "sha256-1uGAP/OLo/lr4PHEBS+R4odkpNJl7oSIYx9cfCQKsC4=";
  };

in
stdenv.mkDerivation {
  inherit pname version src patches;

  buildInputs = [
    libcap
    libgcrypt
    libgpg-error
    libsecret
    qt5compat
    qtbase
    qtnetworkauth
    qtsvg
    qtwebsockets
  ];
  nativeBuildInputs = [
    cargo
    cmake
    go
    pkg-config
    python3
    python3.pkgs.glean-parser
    python3.pkgs.pyyaml
    python3.pkgs.setuptools
    qttools
    rustPlatform.cargoSetupHook
    rustc
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

    pushd source/qtglean
    cargoDeps='${qtgleanDeps}' cargoSetupPostUnpackHook
    qtgleanDepsCopy="$cargoDepsCopy"
    popd
  '';
  dontCargoSetupPostUnpack = true;

  postPatch = ''
    substituteInPlace src/cmake/linux.cmake \
      --replace '/etc/xdg/autostart' "$out/etc/xdg/autostart" \
      --replace '/usr/share/dbus-1' "$out/share/dbus-1" \
      --replace '${"$"}{SYSTEMD_UNIT_DIR}' "$out/lib/systemd/system"

    substituteInPlace extension/CMakeLists.txt \
      --replace '/etc' "$out/etc"

    ln -s '${netfilterGoModules}' linux/netfilter/vendor

    pushd extension/bridge
    cargoDepsCopy="$extensionBridgeDepsCopy" cargoSetupPostPatchHook
    popd

    pushd signature
    cargoDepsCopy="$signatureDepsCopy" cargoSetupPostPatchHook
    popd

    pushd qtglean
    cargoDepsCopy="$qtgleanDepsCopy" cargoSetupPostPatchHook
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
