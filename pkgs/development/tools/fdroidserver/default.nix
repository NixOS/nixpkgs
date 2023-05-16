{ lib
, fetchFromGitLab
<<<<<<< HEAD
, fetchPypi
, apksigner
, buildPythonApplication
, python3
, pythonRelaxDepsHook
, androguard
, babel
, clint
, defusedxml
, gitpython
, libcloud
, mwclient
, paramiko
, pillow
, pyasn1
, pyasn1-modules
, python-vagrant
, pyyaml
, qrcode
, requests
, ruamel-yaml
, yamllint
}:

buildPythonApplication rec {
  pname = "fdroidserver";
  version = "2.2.1";
  format = "setuptools";
=======
, python
, apksigner
}:

python.pkgs.buildPythonApplication rec {
  pname = "fdroidserver";
  version = "2.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    owner = "fdroid";
    repo = "fdroidserver";
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    sha256 = "sha256-+Y1YTgELsX834WIrhx/NX34yLMHdkKM+YUNvnHPiC/s=";
  };

  pythonRelaxDeps = [
    "pyasn1"
    "pyasn1-modules"
  ];

=======
    rev = version;
    sha256 = "0qg4vxjcgm05dqk3kyj8lry9wh5bxy0qwz70fiyxb5bi1kwai9ss";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postPatch = ''
    substituteInPlace fdroidserver/common.py \
      --replace "FDROID_PATH = os.path.realpath(os.path.join(os.path.dirname(__file__), '..'))" "FDROID_PATH = '$out/bin'"
  '';

  preConfigure = ''
<<<<<<< HEAD
    ${python3.pythonForBuild.interpreter} setup.py compile_catalog
=======
    ${python.pythonForBuild.interpreter} setup.py compile_catalog
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  postInstall = ''
    patchShebangs gradlew-fdroid
    install -m 0755 gradlew-fdroid $out/bin
  '';

<<<<<<< HEAD
  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  buildInputs = [
    babel
  ];

  propagatedBuildInputs = [
=======
  buildInputs = with python.pkgs; [
    babel
  ];

  propagatedBuildInputs = with python.pkgs; [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    androguard
    clint
    defusedxml
    gitpython
    libcloud
    mwclient
    paramiko
    pillow
    pyasn1
    pyasn1-modules
    python-vagrant
    pyyaml
    qrcode
    requests
<<<<<<< HEAD
    (ruamel-yaml.overrideAttrs (old: {
      src = fetchPypi {
        pname = "ruamel.yaml";
        version = "0.17.21";
        hash = "sha256-i3zml6LyEnUqNcGsQURx3BbEJMlXO+SSa1b/P10jt68=";
      };
    }))
    yamllint
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    "${lib.makeBinPath [ apksigner ]}"
  ];
=======
    ruamel-yaml
    yamllint
  ];

  makeWrapperArgs = [ "--prefix" "PATH" ":" "${lib.makeBinPath [ apksigner ]}" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # no tests
  doCheck = false;

<<<<<<< HEAD
  pythonImportsCheck = [
    "fdroidserver"
  ];

  meta = with lib; {
    homepage = "https://github.com/f-droid/fdroidserver";
    changelog = "https://github.com/f-droid/fdroidserver/blob/${version}/CHANGELOG.md";
    description = "Server and tools for F-Droid, the Free Software repository system for Android";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ linsui jugendhacker ];
  };
=======
  pythonImportsCheck = [ "fdroidserver" ];

  meta = with lib; {
    homepage = "https://f-droid.org";
    description = "Server and tools for F-Droid, the Free Software repository system for Android";
    license = licenses.agpl3;
    maintainers = with maintainers; [ obfusk ];
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
