{ lib
, fetchFromGitHub
, fetchpatch
, wrapQtAppsHook
, python3
, pynitrokey
}:

let
  python' = python3.override {
    self = python';
    packageOverrides = final: prev: {
      pyqt5 = prev.pyqt5.override {
        withConnectivity = true;
        withMultimedia = true;
        withLocation = true;
        withSerialPort = true;
        withTools = true;
      };

      pyqt5-stubs = final.callPackage ./pyqt5-stubs.nix { };
    };
  };

  inherit (python'.pkgs) buildPythonApplication pythonOlder pyudev pyqt5-stubs;
in

buildPythonApplication rec {
  pname = "nitrokey-app2";
  version = "2.0.1";
  format = "flit";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Nitrokey";
    repo = "nitrokey-app2";
    rev = "v${version}";
    hash = "sha256-RCHXFlZUtBycCO+1nMAqRJliFZcbCqCo7HFmKagYa7U=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/Nitrokey/nitrokey-app2/commit/3c20cf98216ed77ff9014d983fe2a242fbbeee07.patch";
      name = "fix-entry-point.patch";
      hash = "sha256-yP2Bjf4cOFukT/ImkW33xMiE89w4KlO0CCLdTiQ7Pus=";
    })
    (fetchpatch {
      url = "https://github.com/Nitrokey/nitrokey-app2/commit/8b980ef1f556919c6d94265d896c7dbdd7f8fd79.patch";
      name = "add-name-check-to-main.patch";
      hash = "sha256-Zxn2CUkKrk0P+4a9kWEikqBwU8OpreHWqqhyH8jv8L0=";
    })
  ];

  postPatch = ''
    # upstream pins the exact version :-(
    substituteInPlace pyproject.toml \
      --replace 'pynitrokey ==0.4.35' 'pynitrokey >=0.4.35'
  '';

  nativeBuildInputs = [
    wrapQtAppsHook
    # for running pyrcc5 and pyuic5
    pyqt5-stubs
  ];

  propagatedBuildInputs = [
    pyudev
    pyqt5-stubs
    pynitrokey
  ];

  # the pyproject.toml file seems to be incomplete and does not generate
  # resources (i.e. run pyrcc5 and pyuic5) but the Makefile can do it
  preBuild = ''
    make build-ui
  '';

  dontWrapQtApps = true;

  preFixup = ''
    wrapQtApp "$out/bin/nitrokeyapp"
  '';

  pythonImportsCheck = [
    "nitrokeyapp"
  ];

  meta = with lib; {
    description = "Graphical application to manage Nitrokey devices";
    homepage = "https://github.com/Nitrokey/nitrokey-app2";
    license = licenses.asl20;
    maintainers = with maintainers; [ panicgh frogamic ];
    mainProgram = "nitrokeyapp";
  };
}
