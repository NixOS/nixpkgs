{ buildGoModule
, cmake
, fetchFromGitHub
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
  version = "2.10.1";
  src = fetchFromGitHub {
    owner = "mozilla-mobile";
    repo = "mozilla-vpn-client";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-am2acceDig7tjhkO5GiWfvkq0Mabyxedbc8mR49SXBU=";
  };

  netfilter-go-modules = (buildGoModule {
    inherit pname version src;
    modRoot = "linux/netfilter";
    vendorHash = "sha256-Cmo0wnl0z5r1paaEf1MhCPbInWeoMhGjnxCxGh0cyO8=";
  }).go-modules;

  extensionBridgeDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}-extension-bridge";
    preBuild = "cd extension/bridge";
    hash = "sha256-sw6iylh3SgCDA1z/xvwNGWrCU2xr7IVPUL4fdOi43lc=";
  };

  signatureDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}-signature";
    preBuild = "cd signature";
    hash = "sha256-gBJIzTTo6i415aHwUsBriokUt2K/r55QCpC6Tv8GXh4=";
  };

in
stdenv.mkDerivation {
  inherit pname version src;

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

    substituteInPlace src/connectionbenchmark/benchmarktaskdownload.cpp \
      --replace 'QT_VERSION >= 0x060400' 'false'

    ln -s '${netfilter-go-modules}' linux/netfilter/vendor

    pushd extension/bridge
    cargoDepsCopy="$extensionBridgeDepsCopy" cargoSetupPostPatchHook
    popd

    pushd signature
    cargoDepsCopy="$signatureDepsCopy" cargoSetupPostPatchHook
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
