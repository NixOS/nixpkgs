{ buildGoModule
, cargo
, cmake
, fetchFromGitHub
, fetchpatch
, go
, lib
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
  version = "2.15.0";
  src = fetchFromGitHub {
    owner = "mozilla-mobile";
    repo = "mozilla-vpn-client";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-eyYrA8ysfmXxlHNUBkGU9ioYrnbx3L1wP9byNz9L/MA=";
  };
  patches = [
    # Force version downgrade for openssl and openssl-sys crates
    (fetchpatch {
      url = "https://github.com/mozilla-mobile/mozilla-vpn-client/commit/5911071ea37d12401af32dcdf2a542ca5049bf2f.patch";
      hash = "sha256-b3yOgn3Et0sYpqzUUdmlGIbzZSz13Q9HW56hyQqRnHc=";
      revert = true;
    })
    # [2.15] Restore qtglean/Cargo.lock
    (fetchpatch {
      url = "https://github.com/mozilla-mobile/mozilla-vpn-client/pull/7026/commits/13c1b77ee4249883a33b6ac240b3ca143b485ba1.patch";
      hash = "sha256-L4D71zreDMLAIbP4x1as9QdNmMC1snUZSwlkKehg5yM=";
    })
  ];

  netfilter-go-modules = (buildGoModule {
    inherit pname version src patches;
    modRoot = "linux/netfilter";
    vendorHash = "sha256-Cmo0wnl0z5r1paaEf1MhCPbInWeoMhGjnxCxGh0cyO8=";
  }).go-modules;

  extensionBridgeDeps = rustPlatform.fetchCargoTarball {
    inherit src patches;
    name = "${pname}-${version}-extension-bridge";
    preBuild = "cd extension/bridge";
    hash = "sha256-R/9ePEhc4qVgg3WC5ng+cD88K/N3PTnx4QWyaZZfRds=";
  };
  signatureDeps = rustPlatform.fetchCargoTarball {
    inherit src patches;
    name = "${pname}-${version}-signature";
    preBuild = "cd signature";
    hash = "sha256-27g2qnnUrxbThM1cHZquQgWQLWDtZaBnlf8PjvQtBJU=";
  };
  qtgleanDeps = rustPlatform.fetchCargoTarball {
    inherit src patches;
    name = "${pname}-${version}-qtglean";
    preBuild = "cd qtglean";
    hash = "sha256-cW+nf+Dho+eSzOBo3xhxki7NXpg0wd5ZM9OMA6iOUl4=";
  };

in
stdenv.mkDerivation {
  inherit pname version src patches;

  buildInputs = [
    libsecret
    polkit
    qt5compat
    qtbase
    qtnetworkauth
    qtsvg
    qtwebsockets
  ];
  nativeBuildInputs = [
    cmake
    go
    pkg-config
    python3
    python3.pkgs.glean-parser
    python3.pkgs.pyyaml
    python3.pkgs.setuptools
    rustPlatform.cargoSetupHook
    cargo
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
    substituteInPlace src/apps/vpn/platforms/linux/daemon/org.mozilla.vpn.dbus.service --replace /usr/bin/mozillavpn "$out/bin/mozillavpn"

    substituteInPlace scripts/addon/build.py \
      --replace 'qtbinpath = args.qtpath' 'qtbinpath = "${qttools.dev}/bin"' \
      --replace 'rcc = os.path.join(qtbinpath, rcc_bin)' 'rcc = "${qtbase.dev}/libexec/rcc"'

    substituteInPlace src/apps/vpn/cmake/linux.cmake \
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
