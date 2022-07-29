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
  version = "2.9.0";
  src = fetchFromGitHub {
    owner = "mozilla-mobile";
    repo = "mozilla-vpn-client";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-arz8hTgQfPFSZesSddcnZoyLfoLQsQT8LIsl+3ZfA0M=";
  };

  netfilter-go-modules = (buildGoModule {
    inherit pname version src;
    vendorSha256 = "KFYMim5U8WlJHValvIBQgEN+17SDv0JVbH03IiyfDc0=";
    modRoot = "linux/netfilter";
  }).go-modules;

  cargoRoot = "extension/bridge";

in
stdenv.mkDerivation {
  inherit pname version src cargoRoot;

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

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    preBuild = "cd ${cargoRoot}";
    hash = "sha256-lJfDLyoVDSFiZyWcBTI085MorWHPcNW4i7ua1+Ip3rA=";
  };

  postPatch = ''
    for file in linux/*.service linux/extra/*.desktop src/platforms/linux/daemon/*.service; do
      substituteInPlace "$file" --replace /usr/bin/mozillavpn "$out/bin/mozillavpn"
    done

    substituteInPlace scripts/addon/build.py \
      --replace 'qtbinpath = args.qtpath' 'qtbinpath = "${qttools.dev}/bin"' \
      --replace 'rcc = os.path.join(qtbinpath, rcc_bin)' 'rcc = "${qtbase.dev}/libexec/rcc"'

    substituteInPlace src/cmake/linux.cmake \
      --replace '${"$"}{SYSTEMD_UNIT_DIR}' "$out/lib/systemd/system"

    ln -s '${netfilter-go-modules}' linux/netfilter/vendor
  '';

  cmakeFlags = [
    "-DQT_LCONVERT_EXECUTABLE=${qttools.dev}/bin/lconvert"
    "-DQT_LUPDATE_EXECUTABLE=${qttools.dev}/bin/lupdate"
    "-DQT_LRELEASE_EXECUTABLE=${qttools.dev}/bin/lrelease"
  ];

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
