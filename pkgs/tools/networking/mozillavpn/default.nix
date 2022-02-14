{ buildGoModule
, fetchFromGitHub
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
  version = "2.7.1";
  src = fetchFromGitHub {
    owner = "mozilla-mobile";
    repo = "mozilla-vpn-client";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-i551UkCOwWnioe1YgCNZAlYiQJ4YDDBMoDZhfbkLTbs=";
  };

  netfilter-go-modules = (buildGoModule {
    inherit pname version src;
    vendorSha256 = "sha256-KFYMim5U8WlJHValvIBQgEN+17SDv0JVbH03IiyfDc0=";
    modRoot = "linux/netfilter";
  }).go-modules;

in
stdenv.mkDerivation {
  inherit pname version src;

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
    which
    wrapQtAppsHook
  ];

  postPatch = ''
    for file in linux/*.service linux/extra/*.desktop src/platforms/linux/daemon/*.service; do
      substituteInPlace "$file" --replace /usr/bin/mozillavpn "$out/bin/mozillavpn"
    done
  '';

  preBuild = ''
    ln -s '${netfilter-go-modules}' linux/netfilter/vendor
    python3 scripts/generate_glean.py
    python3 scripts/importLanguages.py
  '';

  qmakeFlags = [ "USRPATH=$(out)" "ETCPATH=$(out)/etc" ];
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
