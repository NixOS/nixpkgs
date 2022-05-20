{ buildGoModule
, fetchFromGitHub
, fetchpatch
, go
, lib
, pkg-config
, polkit
, python3
, qmake
, qtbase
, qtcharts
, qtgraphicaleffects
, qtnetworkauth
, qtquickcontrols2
, qttools
, qtwebsockets
, rustPlatform
, stdenv
, which
, wireguard-tools
, wrapQtAppsHook
}:

let
  glean_parser_4_1_1 = python3.pkgs.buildPythonPackage rec {
    pname = "glean_parser";
    version = "4.1.1";
    src = python3.pkgs.fetchPypi {
      inherit pname version;
      hash = "sha256-4noazRqjjJNI2kTO714kSp70jZpWmqHWR2vnkgAftLE=";
    };
    nativeBuildInputs = with python3.pkgs; [ setuptools-scm ];
    propagatedBuildInputs = with python3.pkgs; [
      appdirs
      click
      diskcache
      jinja2
      jsonschema
      pyyaml
      setuptools
      yamllint
    ];
    postPatch = ''
      substituteInPlace setup.py --replace '"pytest-runner", ' ""
    '';
    doCheck = false;
  };

  pname = "mozillavpn";
  version = "2.8.0";
  src = fetchFromGitHub {
    owner = "mozilla-mobile";
    repo = "mozilla-vpn-client";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-UmLYs/J6syfMrjA66K33h8ubYqzvmcGf5spIilVVdVk=";
  };

  patches = [
    # Rust bridge: Add Cargo.lock file
    (fetchpatch {
      url = "https://github.com/mozilla-mobile/mozilla-vpn-client/pull/3341/commits/718c7f52756b5a88511da91dafad7af312bb2473.patch";
      hash = "sha256-fG+SATbJpGqpCFXSWEiBo4dYx6RLtJYR0yTdBqN6Fww=";
    })
  ];

  netfilter-go-modules = (buildGoModule {
    inherit pname version src patches;
    vendorSha256 = "KFYMim5U8WlJHValvIBQgEN+17SDv0JVbH03IiyfDc0=";
    modRoot = "linux/netfilter";
  }).go-modules;

  cargoRoot = "extension/bridge";

in
stdenv.mkDerivation {
  inherit pname version src patches cargoRoot;

  buildInputs = [
    polkit
    qtbase
    qtcharts
    qtgraphicaleffects
    qtnetworkauth
    qtquickcontrols2
    qtwebsockets
  ];
  nativeBuildInputs = [
    glean_parser_4_1_1
    go
    pkg-config
    python3
    python3.pkgs.pyyaml
    qmake
    qttools
    rustPlatform.cargoSetupHook
    rustPlatform.rust.cargo
    which
    wrapQtAppsHook
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src patches;
    name = "${pname}-${version}";
    preBuild = "cd ${cargoRoot}";
    hash = "sha256-dnbF1hfm3qoZaPrIimhY2bUzlrYaNVUZ+nyp6NbgP3Y=";
  };

  postPatch = ''
    for file in linux/*.service linux/extra/*.desktop src/platforms/linux/daemon/*.service; do
      substituteInPlace "$file" --replace /usr/bin/mozillavpn "$out/bin/mozillavpn"
    done
  '';

  preBuild = ''
    ln -s '${netfilter-go-modules}' linux/netfilter/vendor
    python3 scripts/utils/generate_glean.py
    python3 scripts/utils/import_languages.py --qt_path '${lib.getDev qttools}/bin'
  '';

  qmakeFlags = [
    "USRPATH=$(out)"
    "ETCPATH=$(out)/etc"
    "CONFIG-=debug" # https://github.com/mozilla-mobile/mozilla-vpn-client/pull/3539
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
